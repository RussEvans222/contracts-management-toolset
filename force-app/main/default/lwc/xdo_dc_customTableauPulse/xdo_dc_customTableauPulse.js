import {api, LightningElement} from 'lwc';
import {nanoId} from 'c/xdoToolCommonJs';
import XdoToolTrackingEventHandlerBase from 'c/xdoToolTrackingEventHandlerBase';
// import TABIMG from "@salesforce/resourceUrl/sampleTableau";
// import TABIMG from "@salesforce/resourceUrl/pulseImg";
import TABIMGUP from "@salesforce/resourceUrl/pulseImgUp";
import TABIMGDOWN from "@salesforce/resourceUrl/pulseImgDown";

export default class Xdo_dc_customTableauPulse extends XdoToolTrackingEventHandlerBase {
    COMPONENT_NAME = 'xdodcTableauPulse';
	HANDLER_REGISTRATION_DELAY = 100;
	VERSION = 'v1';
	NANOID = nanoId();

	// sampleTableauImg = TABIMG;
	tabImg;
	@api title;
	@api timeRange;
	@api currentValue;
	@api changeText;
	@api changeContext;
	@api yLeftTop;
	// @api yLeftMiddle;
	@api yLeftBottom;
	@api yRightTop;
	// @api yRightMiddle;
	@api yRightBottom;
	@api startMetric;
	@api endMetric;
	@api insightText;
	@api chartImgTrend;
    @api cmpWidth;
	scoreIsPositive;
	scoreIsNegative;

    get setCmpWidth() {
        return 'max-width: ' + this.cmpWidth + 'px;';
        console.log('maxWidth: ', this.cmpWidth + 'px;');
    }

	connectedCallback() {
		this.componentName = this.COMPONENT_NAME;
		super.connectedCallback();

		if (this.changeContext.startsWith("-")) {
			this.scoreIsPositive = false;
			this.scoreIsNegative = true;
		} else {
			this.scoreIsPositive = true;
			this.scoreIsNegative = false;
		}
		if (this.chartImgTrend == "Upward") {
			this.tabImg = TABIMGUP;
		} else {
			this.tabImg = TABIMGDOWN;
		}
	}

	renderedCallback() {
		if (!this.hasRendered) {
			window.setTimeout(this.registerTrackingHandlers.bind(this), this.HANDLER_REGISTRATION_DELAY);
			this.hasRendered = true;
		}
	}
}