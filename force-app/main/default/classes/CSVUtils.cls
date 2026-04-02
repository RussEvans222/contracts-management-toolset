/**
 * This class provides some useful utilities for dealing with CSV files (such as parsing, etc.).
 * 
 * @author Jeremy Blankenship (jblankenship@salesforce.com)
 * @version 1.0
 * 
 * History
 * =======
 * v1.0 - 01-27-2022 - Adapted from some code from Joe McMaster.  Original code used some managed packages no longer available
 *                     with the omnistudio package.  Added SSSCsvReader Class to handle the parsing of the CSV file
 * v1.1 - 09-22-2023 - Switched to using Callable 
 */
global with sharing class CSVUtils implements Callable
   {

    public Object call(String action, Map<String, Object> args) {

        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, input, output, options);
    }

    // Remote Action Options
    public final static String OPTION_HEADER    = 'header';      // true|false indicating presence of a header row
    public final static String OPTION_DELIMITER = 'delimiter';   // character/string value used as delimiter in file
    
    
    
    
    public class ParsingException extends Exception {}

    /**
     * Top level call by a Vlocity Remote Action
     *
     * @param inputMap  - The input provided to the Remote Action
     * @param outputMap - Any output to be provided back to the Remote Action
     * @param options   - Any options to aid in the execution of this class
     *
     * @returns true if the method completes successfully, false otherwise
     */ 
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {

        if (methodName == 'load') return load(inputMap, outputMap, options);  
        
        return false;
    }
    
    /**
     * This method will attempt to parse one or more CSV files and convert them into a JSON structure
     *
     * @param inputMap  - The input provided to the Remote Action
     * @param outputMap - The output map provided to the Remote Action
     * @param options   - Any options to aid in the execution of this class
     *
     * @returns true if this method completes successfully, false otherwise
     */
     private Boolean load(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
         
         List<Object> rows = new List<Object>();
         
         // Get the file(s) uploaded
         Map<String, Object> files = (Map<String, Object>)options.get('vlcFilesMap');
         for (String key : files.keySet()) {
             
             // Load the file content
             String fileContent = String.valueOf(files.get(key));
             rows.addAll(processContent(decode(fileContent), options));
         }
         outputMap.put('data', rows);
         
         return true;
     }
    
    /**
     * This method attempts to process the raw CSV file content to produce a Map structure for each row.  It assumes
     * the first row of the content is the header and those fields will be used as the keys for the cells in each row.
     * 
     * @param content  The raw content
     * @param options  The processing options
     * 
     * @return The list of rows, each as a Map object
     * 
     * @throws Exception if there are any problems parsing the data
     */
    private List<Object> processContent(String content, Map<String, Object> options) {
        
        List<Object> maps = new List<Object>();
        
        if (content != null) {
            
            // Get the rows
            List<List<String>> rows = parseCSV(content, options);
    
            if (rows.size() > 0) {
            
                // Assume the first row is the header, unless header=false is set in Remote Options
                List<String> headers = null;
                Integer rowIndex = 0;
                if (!options.containsKey(OPTION_HEADER) || (options.containsKey(OPTION_HEADER) && (Boolean)options.get(OPTION_HEADER))) {
                    headers = rows.get(rowIndex);
                    rowIndex++;
                }

                // Process remaining rows
                for (; rowIndex<rows.size(); rowIndex++) {
                    
                    // Get the values
                    List<String> values = rows.get(rowIndex);
                    
                    // Check for inconsistencies (if we have headers)
                    if (headers != null && (values.size() != headers.size())) {
                        
                        System.debug(System.LoggingLevel.ERROR, '$$$$ Headers -> ' + headers);
                        System.debug(System.LoggingLevel.ERROR, '$$$$ Values  -> ' + values);
                        throw new ParsingException('Number of values (' + values.size() + ') do not match the number of headers (' + headers.size() + ')');
                    }
                    
                    // Create the Map representing this row
                    Map<String, Object> entry = new Map<String, Object>();
                    for (Integer x=values.size()-1; x>=0; x--) {
                        
                        if (headers != null) entry.put(headers.get(x), values.get(x));
                        else entry.put('column' + (x+1), values.get(x));
                    }
                    maps.add(entry);
                }
            }
        }

        return maps;
    }

    /*
     * Here is a CSV parsing function that returns an array (lines) of string arrays (fields). Does not handle newlines in the content though. 
     *  
     * @param contents  The raw content
     * @param options   The processing options
     * 
     * @return List of rows, each containing a list of values 
     */    
    public static List<List<String>> parseCSV(String contents, Map<String, Object> options) {

        List<List<String>> allFields = new List<List<String>>();
        
        // Assume the delimiter is a comma, unless it is set in the options
        String delimiter = ',';
        if (options.containsKey(OPTION_DELIMITER)) delimiter = (String)options.get(OPTION_DELIMITER);

        SSSCsvReader csvReader = new SSSCsvReader(contents, delimiter);
        
        String[] line;
        
        while ((line = csvReader.readLine()) != null) {
            System.debug('Spit out the line');
            System.debug('Line is ' + line);
            
            // Ignore empty rows
            if (line.isEmpty() || (line.size() == 1 && String.isBlank(line.get(0)))) continue;                
               
            System.debug('$$$$ Line -> ' + JSON.serialize(line));
            allFields.add(line);
        }
        
        return allFields;
    }
    
    /*
     * Decodes the raw content content of the file
     * 
     * @param content  The raw content
     * 
     * @return The decoded content as a string
     * 
     * @throws ParsingException if there are any problems decoding the content (i.e. Unsupported format, etc.);
     */
    private String decode(String content) {
        
        //System.debug('$$$$ -> ' + content);
        // The raw content of an uploaded CSV file uses the following format
        // data:text/csv;base64,QmlsbGluZ0FjY291bnQsTmFtZSxTZXJpYWx.......
        //
        // however, it may also look like this if the user has selected "Upload To Content Document" on the OmniScript File Input element
        // which causes the file to instead be uploaded into the Salesforce Files repository and the content then becomes the Id of the File
        // 0691j0000004arwAAA
        //
        // Check to make sure we can process the file in either case
        if (content.contains(',')) { 

            String metadata = content.substring(0, content.indexOf(','));
        
            // Determine the type of data we are dealing with
            if (metadata.contains('data:text/csv;')) {
            
                if (metadata.contains('base64')) return EncodingUtil.base64Decode(content.removeStart(metadata + ',')).toString();
                return content.removeStart(metadata + ',');
            }
            else throw new ParsingException('Unable to parse content with type = ' + metadata);
        }
        else {
            
            // Try to pull the file content out of Salesforce Content
            List<ContentVersion> contentVersions = (List<ContentVersion>)Database.query('SELECT FileType, VersionData FROM ContentVersion WHERE ContentDocumentId=\'' + content + '\' AND IsLatest=true LIMIT 1');
            if (!contentVersions.isEmpty()) {

                ContentVersion version = contentVersions.get(0);

                if (version.FileType.equalsIgnoreCase('CSV')) {

                    // Stored as a Blob, so just convert it to a String
                    return version.VersionData.toString();
                }
                else throw new ParsingException('Unable to parse file type "' + version.FileType + '".');
            }
            else throw new ParsingException('Unable to retrieve Content Document with Id=' + content + ' from Salesforce Files Repository.');
        }
    }
    
}