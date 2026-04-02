import { api, LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getContractHistoryTimeline from '@salesforce/apex/SDO_ContractHistoryTimelineController.getContractHistoryTimeline';

const EMPTY_VALUE_LABEL = '(blank)';
const AXIS_TICK_COUNT = 6;
const MIN_TIMELINE_SPAN_MS = 60 * 1000;
const MIN_START_SHIFT_MS = 60 * 60 * 1000;
const ZOOM_LEVELS = [1, 2, 4, 8];
const LEGEND_FOCUS_ZOOM_LEVEL = 4;
const MARKER_EDGE_PADDING_PCT = 1.5;
const MARKER_HOVER_PREVIEW_LIMIT = 4;
const MARKER_TYPE_PRIORITY = ['signed', 'approval', 'authored', 'call', 'email', 'task', 'meeting', 'history'];
const MARKER_TYPE_META = {
    signed: { iconName: 'utility:signature', label: 'Contract Signed', themeClass: 'marker-theme-signed' },
    approval: { iconName: 'utility:check', label: 'Approval', themeClass: 'marker-theme-approval' },
    authored: { iconName: 'utility:edit', label: 'Authoring', themeClass: 'marker-theme-authored' },
    call: { iconName: 'utility:call', label: 'Call', themeClass: 'marker-theme-call' },
    email: { iconName: 'standard:email', label: 'Email', themeClass: 'marker-theme-email' },
    task: { iconName: 'standard:task', label: 'Task', themeClass: 'marker-theme-task' },
    meeting: { iconName: 'standard:event', label: 'Meeting', themeClass: 'marker-theme-meeting' },
    history: { iconName: 'utility:trail', label: 'Contract Update', themeClass: 'marker-theme-history' }
};

export default class ContractHistoryTimeline extends LightningElement {
    @api recordId;
    @api maxRows = 800;

    activeScale = 'DAY';

    payload;
    timelineEvents = [];
    bucketRows = [];
    timelineMarkers = [];
    timelineStems = [];
    axisTicks = [];
    selectedBucketKey;
    timelineStartMs;
    timelineEndMs;
    selectedZoom = 1;
    selectedMarkerTypes = [...MARKER_TYPE_PRIORITY];
    selectedDetailEventRowKey;
    selectedDetailMarkerType;
    pendingFocusMarkerType;
    pendingFocusBucketKey;
    needsSnapToToday = false;

    errorMessage;
    wiredTimelineResult;

    @wire(getContractHistoryTimeline, { contractId: '$recordId', maxRows: '$maxRows' })
    wiredTimeline(value) {
        this.wiredTimelineResult = value;
        const { data, error } = value;

        if (data) {
            this.payload = data;
            this.timelineEvents = this.mapEvents(data.events || []);
            this.errorMessage = undefined;
            this.rebuildTimeline();
            return;
        }

        if (error) {
            this.payload = null;
            this.timelineEvents = [];
            this.bucketRows = [];
            this.timelineMarkers = [];
            this.timelineStems = [];
            this.axisTicks = [];
            this.selectedBucketKey = null;
            this.selectedDetailEventRowKey = null;
            this.selectedDetailMarkerType = null;
            this.errorMessage = this.reduceError(error);
        }
    }

    get hasEvents() {
        return this.getFilteredTimelineEvents().length > 0;
    }

    get showTruncationNote() {
        return this.payload?.isTruncated === true;
    }

    get truncationNote() {
        if (!this.showTruncationNote) {
            return '';
        }
        return `Showing ${this.payload.returnedEvents} of ${this.payload.totalAvailableEvents} history rows.`;
    }

    get eventCountLabel() {
        const filteredCount = this.getFilteredTimelineEvents().length;
        const returnedCount = this.payload?.returnedEvents ?? this.timelineEvents.length;
        const totalCount = this.payload?.totalAvailableEvents ?? returnedCount;

        if (returnedCount < totalCount) {
            return `${filteredCount}/${returnedCount} shown (${totalCount} total)`;
        }
        if (filteredCount < returnedCount) {
            return `${filteredCount}/${returnedCount} shown`;
        }
        return `${filteredCount} events`;
    }

    get rangeLabel() {
        const filteredEvents = this.getFilteredTimelineEvents();
        if (!filteredEvents.length) {
            return 'No range for active legend filters';
        }

        const newest = this.formatDate(filteredEvents[0].createdDate, 'short');
        const oldest = this.formatDate(filteredEvents[filteredEvents.length - 1].createdDate, 'short');
        if (newest === oldest) {
            return newest;
        }
        return `${oldest} → ${newest}`;
    }

    get activeScaleLabel() {
        const labelByScale = {
            MINUTE: 'Minute',
            HOUR: 'Hour',
            DAY: 'Day'
        };
        return labelByScale[this.activeScale] || 'Day';
    }

    get zoomButtons() {
        return ZOOM_LEVELS.map((zoomValue) => ({
            value: zoomValue,
            label: zoomValue === 1 ? 'All' : `${zoomValue}x`,
            className: zoomValue === this.selectedZoom ? 'zoom-btn zoom-btn-active' : 'zoom-btn'
        }));
    }

    get timelineCanvasStyle() {
        const widthPct = Math.max(100, this.selectedZoom * 100);
        const minWidth = this.selectedZoom > 1 ? 1200 : 960;
        return `width:${widthPct}%; min-width:${minWidth}px;`;
    }

    get zoomStatusLabel() {
        return this.selectedZoom === 1 ? 'Zoom: All history' : `Zoom: ${this.selectedZoom}x (anchored to today)`;
    }

    get markerLegendItems() {
        const selected = new Set(this.selectedMarkerTypes);
        return MARKER_TYPE_PRIORITY.map((typeKey) => ({
            key: typeKey,
            iconName: MARKER_TYPE_META[typeKey].iconName,
            label: MARKER_TYPE_META[typeKey].label,
            isActive: selected.has(typeKey),
            className: selected.has(typeKey) ? 'legend-btn legend-btn-active' : 'legend-btn'
        }));
    }

    get currentDateLabel() {
        return this.formatWithOptions(new Date(), {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        });
    }

    get selectedBucket() {
        if (!this.selectedBucketKey) {
            return null;
        }
        return this.bucketRows.find((bucket) => bucket.bucketKey === this.selectedBucketKey) || null;
    }

    get hasSelectedBucket() {
        return !!this.selectedBucket;
    }

    get selectedBucketEvents() {
        const events = this.selectedBucket?.events || [];
        if (!events.length) {
            return [];
        }

        if (this.selectedDetailEventRowKey) {
            const eventMatch = events.filter((eventRow) => eventRow.rowKey === this.selectedDetailEventRowKey);
            if (eventMatch.length) {
                return eventMatch;
            }
        }

        if (this.selectedDetailMarkerType) {
            const markerMatches = events.filter(
                (eventRow) => (eventRow.markerType || 'history') === this.selectedDetailMarkerType
            );
            if (markerMatches.length) {
                return markerMatches;
            }
        }

        return events;
    }

    get selectedBucketSummary() {
        const bucket = this.selectedBucket;
        if (!bucket) {
            return '';
        }
        const shownCount = this.selectedBucketEvents.length;
        const totalCount = (bucket.events || []).length;
        if (shownCount !== totalCount) {
            return `${shownCount} of ${totalCount} changes shown in this ${this.activeScaleLabel.toLowerCase()} bucket.`;
        }
        return `${bucket.countLabel} in this ${this.activeScaleLabel.toLowerCase()} bucket.`;
    }

    get emptyMessage() {
        if (this.timelineEvents.length > 0 && this.getFilteredTimelineEvents().length === 0) {
            return 'No timeline events match the selected legend filters.';
        }
        return 'No contract history rows were found for this record yet.';
    }

    async handleRefresh() {
        if (!this.wiredTimelineResult) {
            return;
        }
        await refreshApex(this.wiredTimelineResult);
    }

    handleZoomSelect(event) {
        const nextZoom = Number(event.currentTarget?.dataset?.zoom);
        if (!nextZoom || nextZoom === this.selectedZoom) {
            return;
        }
        this.selectedZoom = nextZoom;
        if (this.selectedZoom > 1) {
            this.needsSnapToToday = true;
        }
    }

    handleJumpToToday() {
        this.snapToToday();
    }

    handleSelectBucket(event) {
        const nextKey = event.currentTarget?.dataset?.bucketKey;
        if (!nextKey) {
            return;
        }

        const nextEventRowKey = event.currentTarget?.dataset?.eventRowKey;
        const nextMarkerType = event.currentTarget?.dataset?.markerType;

        this.selectedBucketKey = nextKey;
        this.selectedDetailEventRowKey = nextEventRowKey || null;
        this.selectedDetailMarkerType = nextMarkerType || null;
        this.bucketRows = this.bucketRows.map((bucket) => {
            const selected = bucket.bucketKey === this.selectedBucketKey;
            return {
                ...bucket,
                markerClass: this.composeMarkerClass(bucket, selected)
            };
        });
        this.timelineMarkers = this.timelineMarkers.map((marker) => ({
            ...marker,
            markerClass: this.composeMarkerClass(marker, marker.bucketKey === this.selectedBucketKey)
        }));
    }

    handleLegendToggle(event) {
        const markerType = event.currentTarget?.dataset?.markerType;
        if (!markerType) {
            return;
        }

        const currentSelection = Array.isArray(this.selectedMarkerTypes) && this.selectedMarkerTypes.length
            ? [...this.selectedMarkerTypes]
            : [...MARKER_TYPE_PRIORITY];
        const isAllSelected = this.hasSameTypes(currentSelection, MARKER_TYPE_PRIORITY);
        const isSingleSelection = currentSelection.length === 1;

        let nextSelection;
        if (isAllSelected) {
            nextSelection = [markerType];
        } else if (isSingleSelection && currentSelection[0] === markerType) {
            nextSelection = [...MARKER_TYPE_PRIORITY];
        } else {
            nextSelection = [markerType];
        }

        this.selectedMarkerTypes = nextSelection;
        this.pendingFocusMarkerType = nextSelection.length === 1 ? markerType : null;
        if (this.pendingFocusMarkerType && this.selectedZoom === 1) {
            this.selectedZoom = LEGEND_FOCUS_ZOOM_LEVEL;
        }
        if (!this.pendingFocusMarkerType) {
            this.pendingFocusBucketKey = null;
        }
        this.selectedBucketKey = null;
        this.selectedDetailEventRowKey = null;
        this.selectedDetailMarkerType = null;
        this.rebuildTimeline();
    }

    mapEvents(events) {
        return events.map((eventRow, index) => {
            const oldValue = this.normalizeValue(eventRow.oldValue);
            const newValue = this.normalizeValue(eventRow.newValue);
            const fieldLabel = eventRow.fieldLabel || this.humanizeToken(eventRow.fieldApiName);
            const sourceCategory = eventRow.sourceCategory || 'Field History';
            const iconName = eventRow.iconName || this.iconForSource(sourceCategory);
            const changeType = eventRow.changeType || (sourceCategory === 'Field History' ? 'Event' : 'Activity');
            const hasDelta = oldValue !== EMPTY_VALUE_LABEL || newValue !== EMPTY_VALUE_LABEL;

            return {
                ...eventRow,
                rowKey: eventRow.historyId || `${eventRow.createdDate}-${eventRow.fieldApiName}-${index}`,
                displayFieldLabel: fieldLabel,
                displayOldValue: oldValue,
                displayNewValue: newValue,
                displayUserName: eventRow.createdByName || 'System',
                displaySourceCategory: sourceCategory,
                iconName,
                markerType: this.classifyMarkerType({
                    sourceCategory,
                    fieldLabel,
                    fieldApiName: eventRow.fieldApiName,
                    newValue
                }),
                changeType,
                changeBadgeClass: `change-badge ${this.getChangeBadgeModifier(changeType)}`,
                hasDelta,
                isEventOnly: !hasDelta
            };
        });
    }

    rebuildTimeline() {
        const filteredEvents = this.getFilteredTimelineEvents();
        if (!filteredEvents.length) {
            this.activeScale = this.resolveScale(filteredEvents);
            this.bucketRows = [];
            this.timelineMarkers = [];
            this.timelineStems = [];
            this.axisTicks = [];
            this.selectedBucketKey = null;
            this.selectedDetailEventRowKey = null;
            this.selectedDetailMarkerType = null;
            this.pendingFocusBucketKey = null;
            this.pendingFocusMarkerType = null;
            return;
        }

        const resolvedScale = this.resolveScale(filteredEvents);
        this.activeScale = resolvedScale;

        const byBucket = new Map();
        filteredEvents.forEach((eventRow) => {
            const eventDate = new Date(eventRow.createdDate);
            const bucketDate = this.floorDateToScale(eventDate, resolvedScale);
            const bucketKey = bucketDate.toISOString();

            if (!byBucket.has(bucketKey)) {
                byBucket.set(bucketKey, {
                    bucketKey,
                    bucketDate,
                    bucketMs: bucketDate.getTime(),
                    events: [],
                    count: 0
                });
            }

            const bucket = byBucket.get(bucketKey);
            bucket.events.push(eventRow);
            bucket.count += 1;
        });

        const orderedBuckets = Array.from(byBucket.values()).sort((a, b) => a.bucketMs - b.bucketMs);
        const nowMs = Date.now();
        const oldestMs = orderedBuckets[0].bucketMs;
        let startMs = Math.min(oldestMs, nowMs);
        let endMs = nowMs;

        if (endMs - startMs < MIN_TIMELINE_SPAN_MS) {
            startMs = endMs - Math.max(MIN_TIMELINE_SPAN_MS, MIN_START_SHIFT_MS);
        }

        const spanMs = Math.max(MIN_TIMELINE_SPAN_MS, endMs - startMs);

        this.timelineStartMs = startMs;
        this.timelineEndMs = endMs;

        const nextRows = orderedBuckets.map((bucket) => {
            const rawPosition = ((bucket.bucketMs - startMs) / spanMs) * 100;
            const positionPct = Math.max(0, Math.min(100, rawPosition));
            const bucketLabel = this.formatBucketLabel(bucket.bucketDate, resolvedScale);
            const markerProfile = this.buildBucketMarkerProfile(bucket.events);
            const previewItems = bucket.events.slice(0, MARKER_HOVER_PREVIEW_LIMIT).map((eventRow) => eventRow.displayFieldLabel);
            const remainingCount = Math.max(0, bucket.events.length - previewItems.length);
            const previewSuffix = remainingCount > 0 ? ` (+${remainingCount} more)` : '';
            const hoverDetail = previewItems.join(' | ');
            const markerTitle = hoverDetail
                ? `${bucketLabel} • ${bucket.count} changes • ${markerProfile.label}\n${hoverDetail}${previewSuffix}`
                : `${bucketLabel} • ${bucket.count} changes • ${markerProfile.label}`;

            return {
                ...bucket,
                rowKey: `bucket-${bucket.bucketKey}`,
                label: bucketLabel,
                countLabel: `${bucket.count} ${bucket.count === 1 ? 'change' : 'changes'}`,
                positionPct,
                markerIconName: markerProfile.iconName,
                markerAltText: markerProfile.label,
                markerThemeClass: markerProfile.themeClass,
                title: markerTitle,
                markerClass: this.composeMarkerClass(
                    { markerThemeClass: markerProfile.themeClass, bucketKey: bucket.bucketKey },
                    bucket.bucketKey === this.selectedBucketKey
                )
            };
        });

        const focusBucketKey = this.pendingFocusMarkerType
            ? this.findLatestBucketKeyForMarkerType(nextRows, this.pendingFocusMarkerType)
            : null;
        const nextSelected = focusBucketKey || this.pickSelectedBucketKey(nextRows);
        this.selectedBucketKey = nextSelected;
        this.bucketRows = nextRows.map((bucket) => ({
            ...bucket,
            markerClass: this.composeMarkerClass(bucket, bucket.bucketKey === nextSelected)
        }));
        this.timelineMarkers = this.buildTimelineMarkers(nextRows, startMs, spanMs, nextSelected);
        this.timelineStems = this.buildTimelineStems(this.timelineMarkers);
        this.syncDetailSelection();

        this.axisTicks = this.buildAxisTicks(startMs, endMs, resolvedScale);
        if (focusBucketKey) {
            this.pendingFocusBucketKey = focusBucketKey;
            this.needsSnapToToday = false;
        } else if (this.selectedZoom > 1) {
            this.needsSnapToToday = true;
            this.pendingFocusBucketKey = null;
        }
        this.pendingFocusMarkerType = null;
    }

    pickSelectedBucketKey(nextRows) {
        if (!nextRows.length) {
            return null;
        }
        if (this.selectedBucketKey && nextRows.some((bucket) => bucket.bucketKey === this.selectedBucketKey)) {
            return this.selectedBucketKey;
        }
        return nextRows[nextRows.length - 1].bucketKey;
    }

    syncDetailSelection() {
        if (!this.selectedBucketKey) {
            this.selectedDetailEventRowKey = null;
            this.selectedDetailMarkerType = null;
            return;
        }

        const selectedBucket = this.bucketRows.find((bucket) => bucket.bucketKey === this.selectedBucketKey);
        const bucketEvents = selectedBucket?.events || [];
        if (!bucketEvents.length) {
            this.selectedDetailEventRowKey = null;
            this.selectedDetailMarkerType = null;
            return;
        }

        if (this.selectedDetailEventRowKey) {
            const hasEvent = bucketEvents.some((eventRow) => eventRow.rowKey === this.selectedDetailEventRowKey);
            if (hasEvent) {
                return;
            }
        }
        this.selectedDetailEventRowKey = null;

        if (this.selectedDetailMarkerType) {
            const hasType = bucketEvents.some(
                (eventRow) => (eventRow.markerType || 'history') === this.selectedDetailMarkerType
            );
            if (hasType) {
                return;
            }
        }
        this.selectedDetailMarkerType = null;
    }

    buildAxisTicks(startMs, endMs, scale) {
        const ticks = [];
        const span = Math.max(MIN_TIMELINE_SPAN_MS, endMs - startMs);
        for (let index = 0; index <= AXIS_TICK_COUNT; index++) {
            const pct = (index / AXIS_TICK_COUNT) * 100;
            const tickMs = Math.round(startMs + (span * index) / AXIS_TICK_COUNT);
            ticks.push({
                key: `tick-${index}`,
                style: `left:${pct}%;`,
                label: this.formatAxisTick(tickMs, scale, index)
            });
        }
        return ticks;
    }

    formatAxisTick(timestampMs, scale, index) {
        const date = new Date(timestampMs);
        if (index === AXIS_TICK_COUNT) {
            return 'Now';
        }

        // At deepest zoom, always show explicit time detail on the axis.
        if (this.selectedZoom >= 8) {
            if (scale === 'MINUTE') {
                return this.formatWithOptions(date, {
                    hour: 'numeric',
                    minute: '2-digit',
                    second: '2-digit'
                });
            }
            if (scale === 'HOUR') {
                return this.formatWithOptions(date, {
                    month: 'short',
                    day: 'numeric',
                    hour: 'numeric',
                    minute: '2-digit'
                });
            }
            return this.formatWithOptions(date, {
                month: 'short',
                day: 'numeric',
                hour: 'numeric',
                minute: '2-digit'
            });
        }

        // Axis precision is intentionally one level finer than the bucket scale:
        // Day buckets => hour markings, Hour buckets => minute markings, Minute buckets => second markings.
        if (scale === 'MINUTE') {
            return this.formatWithOptions(date, {
                hour: 'numeric',
                minute: '2-digit',
                second: '2-digit'
            });
        }
        if (scale === 'HOUR') {
            return this.formatWithOptions(date, {
                hour: 'numeric',
                minute: '2-digit'
            });
        }
        return this.formatWithOptions(date, {
            hour: 'numeric'
        });
    }

    resolveScale(eventsInput) {
        const events = eventsInput || this.timelineEvents;
        if (events.length < 2) {
            return 'DAY';
        }

        const newestTime = new Date(events[0].createdDate).getTime();
        const oldestTime = new Date(events[events.length - 1].createdDate).getTime();
        const spanMs = Math.max(0, newestTime - oldestTime);
        const oneDay = 24 * 60 * 60 * 1000;

        if (spanMs <= oneDay || (events.length > 300 && spanMs <= 7 * oneDay)) {
            return 'MINUTE';
        }
        if (spanMs <= 120 * oneDay || (events.length > 140 && spanMs <= 365 * oneDay)) {
            return 'HOUR';
        }
        return 'DAY';
    }

    getFilteredTimelineEvents() {
        if (!this.timelineEvents.length) {
            return [];
        }
        if (!this.selectedMarkerTypes.length) {
            return [];
        }
        const selectedTypes = new Set(this.selectedMarkerTypes);
        return this.timelineEvents.filter((eventRow) => selectedTypes.has(eventRow.markerType || 'history'));
    }

    floorDateToScale(dateValue, scale) {
        const date = new Date(dateValue);
        if (scale === 'MINUTE') {
            date.setSeconds(0, 0);
            return date;
        }
        if (scale === 'HOUR') {
            date.setMinutes(0, 0, 0);
            return date;
        }
        date.setHours(0, 0, 0, 0);
        return date;
    }

    formatBucketLabel(dateValue, scale) {
        if (scale === 'MINUTE') {
            return this.formatWithOptions(dateValue, {
                month: 'short',
                day: 'numeric',
                year: 'numeric',
                hour: 'numeric',
                minute: '2-digit'
            });
        }
        if (scale === 'HOUR') {
            return this.formatWithOptions(dateValue, {
                month: 'short',
                day: 'numeric',
                year: 'numeric',
                hour: 'numeric'
            });
        }
        return this.formatWithOptions(dateValue, {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        });
    }

    formatDate(value, mode) {
        if (!value) {
            return '';
        }
        if (mode === 'short') {
            return this.formatWithOptions(value, {
                month: 'short',
                day: 'numeric',
                year: 'numeric',
                hour: 'numeric',
                minute: '2-digit'
            });
        }
        return this.formatWithOptions(value, {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        });
    }

    formatWithOptions(value, options) {
        return new Intl.DateTimeFormat(undefined, options).format(new Date(value));
    }

    normalizeValue(value) {
        if (value === null || value === undefined) {
            return EMPTY_VALUE_LABEL;
        }
        const asString = String(value).trim();
        return asString.length ? asString : EMPTY_VALUE_LABEL;
    }

    getChangeBadgeModifier(changeType) {
        if (changeType === 'Activity') {
            return 'change-badge-activity';
        }
        if (changeType === 'Set') {
            return 'change-badge-set';
        }
        if (changeType === 'Cleared') {
            return 'change-badge-cleared';
        }
        if (changeType === 'Updated') {
            return 'change-badge-updated';
        }
        return 'change-badge-event';
    }

    composeMarkerClass(bucket, isSelected) {
        const themeClass = bucket?.markerThemeClass || MARKER_TYPE_META.history.themeClass;
        return `timeline-marker ${themeClass}${isSelected ? ' timeline-marker-selected' : ''}`;
    }

    findLatestBucketKeyForMarkerType(buckets, markerType) {
        if (!Array.isArray(buckets) || !buckets.length || !markerType) {
            return null;
        }
        for (let index = buckets.length - 1; index >= 0; index -= 1) {
            const bucket = buckets[index];
            const hasType = (bucket?.events || []).some(
                (eventRow) => (eventRow.markerType || 'history') === markerType
            );
            if (hasType) {
                return bucket.bucketKey;
            }
        }
        return null;
    }

    hasSameTypes(left, right) {
        if (!Array.isArray(left) || !Array.isArray(right) || left.length !== right.length) {
            return false;
        }
        const leftSet = new Set(left);
        if (leftSet.size !== right.length) {
            return false;
        }
        return right.every((typeKey) => leftSet.has(typeKey));
    }

    buildBucketMarkerProfile(events) {
        const countsByType = {};
        events.forEach((eventRow) => {
            const markerType = eventRow.markerType || 'history';
            countsByType[markerType] = (countsByType[markerType] || 0) + 1;
        });

        let dominantType = 'history';
        let dominantCount = -1;
        MARKER_TYPE_PRIORITY.forEach((typeKey) => {
            const count = countsByType[typeKey] || 0;
            if (count > dominantCount) {
                dominantType = typeKey;
                dominantCount = count;
            }
        });

        return MARKER_TYPE_META[dominantType] || MARKER_TYPE_META.history;
    }

    buildTimelineMarkers(bucketRows, startMs, spanMs, selectedBucketKey) {
        if (!Array.isArray(bucketRows) || !bucketRows.length) {
            return [];
        }

        const markerSize = this.activeScale === 'MINUTE' ? 22 : 20;
        const markerOffset = markerSize / 2;
        const markers = [];

        bucketRows.forEach((bucket) => {
            const timestampTotals = new Map();
            const timestampSeen = new Map();

            (bucket.events || []).forEach((eventRow) => {
                const eventMs = new Date(eventRow.createdDate).getTime();
                timestampTotals.set(eventMs, (timestampTotals.get(eventMs) || 0) + 1);
            });

            (bucket.events || []).forEach((eventRow) => {
                const eventMs = new Date(eventRow.createdDate).getTime();
                const totalForTimestamp = timestampTotals.get(eventMs) || 1;
                const seenForTimestamp = timestampSeen.get(eventMs) || 0;
                timestampSeen.set(eventMs, seenForTimestamp + 1);

                const rawPosition = ((eventMs - startMs) / spanMs) * 100;
                let markerPositionPct = Math.max(
                    MARKER_EDGE_PADDING_PCT,
                    Math.min(100 - MARKER_EDGE_PADDING_PCT, rawPosition)
                );

                if (totalForTimestamp > 1) {
                    const spreadStepPct = this.activeScale === 'MINUTE' ? 0.12 : 0.2;
                    const centeredOffset = (seenForTimestamp - (totalForTimestamp - 1) / 2) * spreadStepPct;
                    markerPositionPct = Math.max(
                        MARKER_EDGE_PADDING_PCT,
                        Math.min(100 - MARKER_EDGE_PADDING_PCT, markerPositionPct + centeredOffset)
                    );
                }

                const markerType = eventRow.markerType || 'history';
                const markerMeta = MARKER_TYPE_META[markerType] || MARKER_TYPE_META.history;
                const markerLabel = this.formatDate(eventRow.createdDate, 'short');
                const markerTitle = `${markerLabel} • ${eventRow.displaySourceCategory} • ${eventRow.displayFieldLabel}`;

                markers.push({
                    rowKey: `marker-${bucket.bucketKey}-${eventRow.rowKey}`,
                    eventRowKey: eventRow.rowKey,
                    bucketKey: bucket.bucketKey,
                    markerType,
                    markerThemeClass: markerMeta.themeClass,
                    markerIconName: markerMeta.iconName,
                    markerAltText: markerMeta.label,
                    title: markerTitle,
                    positionPct: markerPositionPct,
                    markerStyle: `left: calc(${markerPositionPct}% - ${markerOffset}px); width:${markerSize}px; height:${markerSize}px;`,
                    markerClass: this.composeMarkerClass(
                        { markerThemeClass: markerMeta.themeClass, bucketKey: bucket.bucketKey },
                        bucket.bucketKey === selectedBucketKey
                    )
                });
            });
        });

        return markers;
    }

    buildTimelineStems(markers) {
        return (markers || []).map((marker, index) => ({
            rowKey: `stem-${marker.rowKey}-${index}`,
            stemStyle: `left: ${marker.positionPct}%;`
        }));
    }

    classifyMarkerType(eventRow) {
        const sourceCategory = (eventRow?.sourceCategory || '').toLowerCase();
        const fieldLabel = (eventRow?.fieldLabel || '').toLowerCase();
        const fieldApiName = (eventRow?.fieldApiName || '').toLowerCase();
        const newValue = (eventRow?.newValue || '').toLowerCase();

        if (sourceCategory === 'approval') {
            return 'approval';
        }
        if (sourceCategory === 'email') {
            return 'email';
        }
        if (sourceCategory === 'event') {
            return 'meeting';
        }
        if (sourceCategory === 'task') {
            if (/type:\s*email/i.test(newValue) || fieldLabel.includes('email')) {
                return 'email';
            }
            if (/type:\s*call/i.test(newValue) || fieldLabel.includes('call')) {
                return 'call';
            }
            return 'task';
        }

        if (fieldApiName === 'status' || fieldLabel.includes('status')) {
            if (/\bsigned\b/.test(newValue) || /\bactivated\b/.test(newValue)) {
                return 'signed';
            }
            if (/\bdraft\b/.test(newValue) || /\bin approval\b/.test(newValue) || /\bnegotiating\b/.test(newValue) || /\bawaiting signature\b/.test(newValue)) {
                return 'authored';
            }
        }

        if (fieldLabel.includes('author') || fieldLabel.includes('draft')) {
            return 'authored';
        }
        return 'history';
    }

    iconForSource(sourceCategory) {
        if (sourceCategory === 'Approval') {
            return 'utility:check';
        }
        if (sourceCategory === 'Task') {
            return 'standard:task';
        }
        if (sourceCategory === 'Event') {
            return 'standard:event';
        }
        if (sourceCategory === 'Email') {
            return 'standard:email';
        }
        return 'utility:trail';
    }

    humanizeToken(value) {
        if (!value) {
            return 'System Event';
        }
        return value
            .replace(/__c$/i, '')
            .replace(/__/g, ' ')
            .replace(/_/g, ' ')
            .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
            .replace(/\s+/g, ' ')
            .trim()
            .replace(/\b\w/g, (match) => match.toUpperCase());
    }

    reduceError(error) {
        if (!error) {
            return 'Unknown error while loading contract history timeline.';
        }
        if (Array.isArray(error.body)) {
            return error.body.map((entry) => entry.message).join(', ');
        }
        if (typeof error.body?.message === 'string') {
            return error.body.message;
        }
        if (typeof error.message === 'string') {
            return error.message;
        }
        return 'Unable to load contract history timeline.';
    }

    renderedCallback() {
        if (this.pendingFocusBucketKey) {
            const focusBucketKey = this.pendingFocusBucketKey;
            this.pendingFocusBucketKey = null;
            this.scrollBucketIntoView(focusBucketKey);
            return;
        }
        if (!this.needsSnapToToday) {
            return;
        }
        this.needsSnapToToday = false;
        this.snapToToday();
    }

    snapToToday() {
        const plotContainer = this.template.querySelector('.timeline-plot');
        if (!plotContainer) {
            return;
        }
        plotContainer.scrollLeft = Math.max(0, plotContainer.scrollWidth - plotContainer.clientWidth);
    }

    scrollBucketIntoView(bucketKey) {
        if (!bucketKey) {
            return;
        }
        const plotContainer = this.template.querySelector('.timeline-plot');
        if (!plotContainer) {
            return;
        }
        const marker = Array.from(this.template.querySelectorAll('.timeline-marker')).find(
            (element) => element.dataset.bucketKey === bucketKey
        );
        if (!marker) {
            return;
        }

        const plotRect = plotContainer.getBoundingClientRect();
        const markerRect = marker.getBoundingClientRect();
        const markerCenter = markerRect.left + markerRect.width / 2;
        const plotCenter = plotRect.left + plotRect.width / 2;
        const delta = markerCenter - plotCenter;
        const maxScrollLeft = Math.max(0, plotContainer.scrollWidth - plotContainer.clientWidth);
        const targetScroll = Math.max(0, Math.min(maxScrollLeft, plotContainer.scrollLeft + delta));
        plotContainer.scrollLeft = targetScroll;
    }
}
