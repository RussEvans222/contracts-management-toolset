global class ngo_IDO_BugConnection extends DataSource.Connection {
    global ngo_IDO_BugConnection(DataSource.ConnectionParams connectionsParams) {}


    override global List<DataSource.Table> sync() {
        List<DataSource.Table> tables = new List<DataSource.Table>();
        List<DataSource.Column> columns = new List<DataSource.Column>();

        columns.add(DataSource.Column.text('Name', 255));
        columns.add(DataSource.Column.text('Description', 10000));  // Extended for HTML-formatted README content
        columns.add(DataSource.Column.text('Bug Id', 255));
        columns.add(DataSource.Column.url('videoURL'));
        

        columns.add(DataSource.Column.text('ExternalId', 255)); 
        columns.add(DataSource.Column.url('DisplayUrl'));       

        tables.add(DataSource.Table.get('NGO_IDO_Bug', 'Name', columns));
        return tables;
    }


    override global DataSource.TableResult query(DataSource.QueryContext context) {
        return DataSource.TableResult.get(true, null, context.tableSelection.tableSelected, getRows());
    }


    private List<Map<String, Object>> getRows() {
        List<Map<String, Object>> rows = new List<Map<String, Object>>();


        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:ngo_Heroku_OData/public$bugs');   
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
    

    Object postgresId = data.get('id'); 

    row.put('ExternalId', String.valueOf(postgresId)); 
    row.put('Name', (String)data.get('name'));
    row.put('Description', (String)data.get('description'));
    row.put('Bug Id', (String)data.get('bug_id'));
    row.put('videoURL', (String)data.get('videoURL'));

    rows.add(row);
}
            } else {
                System.debug('Heroku Callout Failed. Status: ' + res.getStatus() + ' Body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Error in NGO_IDO_BugConnection: ' + e.getMessage());
        }
        
        return rows;
    }
}