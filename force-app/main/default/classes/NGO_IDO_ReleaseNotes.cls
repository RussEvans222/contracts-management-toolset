global class NGO_IDO_ReleaseNotes extends DataSource.Connection {
    global NGO_IDO_ReleaseNotes(DataSource.ConnectionParams connectionsParams) {}

    /**
     * SYNC: Defines tables so Salesforce sees them as External Objects.
     */
    override global List<DataSource.Table> sync() {
        List<DataSource.Table> tables = new List<DataSource.Table>();

        // --- Configuration for Bugs Table ---
        List<DataSource.Column> bugCols = new List<DataSource.Column>();
        bugCols.add(DataSource.Column.text('Name', 255));
        bugCols.add(DataSource.Column.text('Description', 10000));
        bugCols.add(DataSource.Column.text('Bug Id', 255));
        bugCols.add(DataSource.Column.url('videoURL'));
        bugCols.add(DataSource.Column.text('ExternalId', 255)); 
        bugCols.add(DataSource.Column.url('DisplayUrl'));
        tables.add(DataSource.Table.get('NGO_IDO_Bug', 'Name', bugCols));

        // --- Configuration for Release Notes View ---
        List<DataSource.Column> releaseCols = new List<DataSource.Column>();
        releaseCols.add(DataSource.Column.text('Name', 255));
        releaseCols.add(DataSource.Column.text('Description', 32768));
        releaseCols.add(DataSource.Column.url('Video_URL'));
        releaseCols.add(DataSource.Column.text('Product_Line', 100));
        releaseCols.add(DataSource.Column.text('Release_Code', 20));
        releaseCols.add(DataSource.Column.number('Major_Version', 18, 0));
        releaseCols.add(DataSource.Column.boolean('Is_Latest_Major'));
        releaseCols.add(DataSource.Column.text('ExternalId', 255)); 
        releaseCols.add(DataSource.Column.url('DisplayUrl'));
        releaseCols.add(DataSource.Column.text('Type', 20));
        releaseCols.add(DataSource.Column.date('Release_Date'));
        tables.add(DataSource.Table.get('v_product_releases', 'Name', releaseCols));

        // --- NEW: Configuration for ABC360 Table ---
        List<DataSource.Column> abcCols = new List<DataSource.Column>();
        abcCols.add(DataSource.Column.text('Name', 255));
        // User requested Long Text Area capability; creating large Text fields
        abcCols.add(DataSource.Column.text('Description', 10000)); 
        abcCols.add(DataSource.Column.text('Flow_Name', 255)); 
        abcCols.add(DataSource.Column.url('Video_URL'));
        abcCols.add(DataSource.Column.text('IDO', 50));
        abcCols.add(DataSource.Column.text('ExternalId', 255));
        abcCols.add(DataSource.Column.url('DisplayUrl'));
        abcCols.add(DataSource.Column.text('Brix_Name', 255));
        tables.add(DataSource.Table.get('Ngo_ABC360', 'Name', abcCols));

        return tables;
    }

    /**
     * QUERY: Routes the request and applies filtering in-memory via QueryUtils.
     */
    override global DataSource.TableResult query(DataSource.QueryContext context) {
        String entity = context.tableSelection.tableSelected;
        
        List<Map<String, Object>> allRows;
        if (entity == 'NGO_IDO_Bug') {
            allRows = getRows('public$bugs');
        } else if (entity == 'Ngo_ABC360') {
            allRows = getRows('public$abc360');
        } else {
            allRows = getRows('public$v_product_releases');
        }

        // Apply filters, sorts, and limits in-memory using Salesforce's utility
        List<Map<String, Object>> filteredRows = DataSource.QueryUtils.process(context, allRows);

        return DataSource.TableResult.get(true, null, entity, filteredRows);
    }

    /**
     * GET ROWS: Fetches data from Heroku and maps it to Salesforce columns.
     */
    private List<Map<String, Object>> getRows(String tableName) {
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('callout:ngo_Heroku_OData/' + tableName);
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');

        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> results = (List<Object>) responseBody.get('value');
                
                for (Object obj : results) {
                    Map<String, Object> data = (Map<String, Object>) obj;
                    Map<String, Object> row = new Map<String, Object>();
                    
                    if (tableName == 'public$bugs') {
                        // Mapping for Bugs
                        row.put('ExternalId', String.valueOf(data.get('id'))); 
                        row.put('Name', (String)data.get('name'));
                        row.put('Description', (String)data.get('description'));
                        row.put('Bug Id', (String)data.get('bug_id'));
                        row.put('videoURL', (String)data.get('videoURL'));
                        row.put('DisplayUrl', (String)data.get('videoURL')); 
                    } else if (tableName == 'public$abc360') {
                        // Mapping for ABC360
                        row.put('ExternalId', String.valueOf(data.get('id')));
                        row.put('Name', (String)data.get('name'));
                        row.put('Description', (String)data.get('description'));
                        row.put('Flow_Name', (String)data.get('flow_name'));
                        row.put('Video_URL', (String)data.get('videoURL'));
                        row.put('IDO', (String)data.get('ido'));
                        row.put('DisplayUrl', (String)data.get('videoURL'));
                        row.put('Brix_Name', (String)data.get('brix_name'));
                    } else {
                        // Mapping for Release Notes
                        row.put('ExternalId', String.valueOf(data.get('external_id'))); 
                        row.put('Name', (String)data.get('feature_name'));
                        row.put('Description', (String)data.get('description'));
                        row.put('Video_URL', (String)data.get('video_url'));
                        row.put('Type', (String)data.get('type'));
                        
                        Object rawDate = data.get('release_date');
                        row.put('Release_Date', rawDate != null ? Date.valueOf((String)rawDate) : null);
                        
                        row.put('Product_Line', (String)data.get('product_line'));
                        row.put('Release_Code', (String)data.get('release_code'));
                        row.put('Major_Version', (Decimal)data.get('major_version'));
                        row.put('Is_Latest_Major', (Boolean)data.get('is_latest_major'));
                        row.put('DisplayUrl', (String)data.get('video_url'));
                    }
                    rows.add(row);
                }
            }
        } catch (Exception e) { System.debug('Callout Error: ' + e.getMessage()); }
        return rows;
    }
}