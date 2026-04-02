global with sharing class IFSUpdateSubmissionStatus implements Callable
{
  // Dispatch actual methods
   public Object call(String action, Map<String, Object> args) {
       
       Map<String, Object> input = (Map<String, Object>)args.get('input');
       Map<String, Object> output = (Map<String, Object>)args.get('output');
       Map<String, Object> options = (Map<String, Object>)args.get('options');

       return invokeMethod(action, input, output, options);
   }
    
   private Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) 
    {
        Boolean result = true; 
        try
        {
            if(methodName.equals('updateSubmissionStatus'))
            {
                Id IFSId = (Id) inputMap.get('IFSId');
                updateSubmissionStatus(IFSId);
            }
        }
        catch(System.Exception e)
        {
            result = false;
        }
        
        return result;
    }
    
    private void updateSubmissionStatus(Id IFSId) {
        IntakeFormSection ifs = [SELECT Id FROM IntakeFormSection WHERE Id = :IFSId LIMIT 1];
        
        ifs.put('isSubmitted', true);
        ifs.put('Status', 'Complete');
        
        update ifs;
    }
}