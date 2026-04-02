global with sharing class ESRIDomainName implements Callable
   {

    public Object call(String action, Map<String, Object> args) {

        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, input, output, options);
    }
                
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
              Boolean result = true;
            
      try{
            
             if(methodName.equals('GetDomain')){
            
                String baseURL = System.Url.getSalesforceBaseUrl().toExternalForm() ;
                String[] splitURL1 = baseURL.split('//');
                String shrink1 = splitURL1[1];
                String[] splitURL2 = shrink1.split('\\.');
                String finalurl = splitURL2[0];
        
                // Added after switch to Standard runtime as --omnistudio was added for some reason and just need the base domain
                Integer endOmnistudio = finalurl.indexOf('--omnistudio');
        
                if (endOmnistudio > -1) {
                    finalurl=finalurl.left(endOmnistudio);
                }
            
                System.debug('finalurl is ' + finalurl);
        
        
                outMap.put('DomainName',finalurl);
                                                            
            
            }
            
                                    
            
      } catch(Exception e){
                       
         result = false;
                    
      }
             
             return result;
                  
   }
            
}