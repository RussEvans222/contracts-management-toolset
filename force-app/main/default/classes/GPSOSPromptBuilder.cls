global with sharing class GPSOSPromptBuilder implements Callable {

    public Object call(String action, Map<String, Object> args) {

        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, input, output, options);
    }
   global Boolean invokeMethod(String methodName,
      Map <String, Object> inputMap,
      Map <String, Object> outMap, Map <String, Object> options) {
         
        if (methodName == 'IdsPrompt') {
         IdsPrompt(inputMap, outMap, options);}
         
      return true;
    }

void IdsPrompt(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        
    String InputId1 = (String)inputMap.get('InputId1');
    String InputId2 = (String)inputMap.get('InputId2');
    String InputId3 = (String)inputMap.get('InputId3');
    String InputId4 = (String)inputMap.get('InputId4');
    String InputId5 = (String)inputMap.get('InputId5');
    
    String PromptTemplateName = (String)options.get('PromptTemplateName');
    
    String InputName1 = (String)options.get('InputName1');
    String InputName2 = (String)options.get('InputName2');
    String InputName3 = (String)options.get('InputName3');
    String InputName4 = (String)options.get('InputName4');
    String InputName5 = (String)options.get('InputName5');

    ConnectApi.EinsteinPromptTemplateGenerationsInput promptGenerationsInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
    promptGenerationsInput.isPreview = false;
    
    // Build input map
    Map<String,ConnectApi.WrappedValue> valueMap = new Map<String,ConnectApi.WrappedValue>();
    
    Map<String, String> InputId1Map = new Map<String, String>();
    InputId1Map.put('id', InputId1); 
    
    ConnectApi.WrappedValue InputId1WrappedValue = new ConnectApi.WrappedValue();
    InputId1WrappedValue.value = InputId1Map;
    
    valueMap.put('Input:'+InputName1,InputId1WrappedValue);
    
    if (InputName2!=null)
    {
        Map<String, String> InputId2Map = new Map<String, String>();
        InputId2Map.put('id', InputId2); 
    
        ConnectApi.WrappedValue InputId2WrappedValue = new ConnectApi.WrappedValue();
        InputId2WrappedValue.value = InputId2Map;
    
        valueMap.put('Input:'+InputName2,InputId2WrappedValue);
     }
     
     if (InputName3!=null)
     {
        Map<String, String> InputId3Map = new Map<String, String>();
        InputId3Map.put('id', InputId3); 
    
        ConnectApi.WrappedValue InputId3WrappedValue = new ConnectApi.WrappedValue();
        InputId3WrappedValue.value = InputId3Map;
    
        valueMap.put('Input:'+InputName3,InputId3WrappedValue);
     }
     
     if (InputName4!=null)
     {
        Map<String, String> InputId4Map = new Map<String, String>();
        InputId4Map.put('id', InputId4); 
    
        ConnectApi.WrappedValue InputId4WrappedValue = new ConnectApi.WrappedValue();
        InputId4WrappedValue.value = InputId4Map;
    
        valueMap.put('Input:'+InputName4,InputId4WrappedValue);
     }
     
     if (InputName5!=null)
     {
        Map<String, String> InputId5Map = new Map<String, String>();
        InputId5Map.put('id', InputId5); 
    
        ConnectApi.WrappedValue InputId5WrappedValue = new ConnectApi.WrappedValue();
        InputId5WrappedValue.value = InputId5Map;
    
        valueMap.put('Input:'+InputName5,InputId5WrappedValue);
     }
    
    promptGenerationsInput.inputParams = valueMap;
    
    // Set additional configuration values
    promptGenerationsInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
    promptGenerationsInput.additionalConfig.applicationName = 'PromptTemplateGenerationsInvocable';
    
    // Call the service
    ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = 
     ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(PromptTemplateName, promptGenerationsInput); 
    
    ConnectApi.EinsteinLlmGenerationSafetyScoreOutput safety = generationsOutput.generations[0].safetyScoreRepresentation;
    
    // Return the Results to the Omniscript
    outputMap.put('PromptResult',generationsOutput.generations[0].text);
    outputMap.put('SafetyScore',safety);
    }
 }