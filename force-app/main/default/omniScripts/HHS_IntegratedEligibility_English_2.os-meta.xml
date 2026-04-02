<?xml version="1.0" encoding="UTF-8"?>
<OmniScript xmlns="http://soap.sforce.com/2006/04/metadata">
    <customHtmlTemplates>&lt;style&gt;
body{background:transparent;}
.vlocity .field-label, .vlocity label, .vlc-check-label{text-transform:none;font-size:14px;}
.vlocity label, .vlc-check-label, .vlocity .field-label, .vlocity .vlc-block-heading{display:inline;color: rgba(0, 0, 0, 0.9);}
.vlocity input[type=&quot;checkbox&quot;]{font-size:36px;}
br{display:none;}
.programDesc{margin-left:20px; margin-bottom: 20px; border: 1px solid #e3e3e3; background-color: #f5f5f5; padding:20px; border-radius: 6px;}
.programDesc p{line-height:18px;margin-bottom:0;}
.programDesc img{float:left;padding-right:20px; width:15%; height:auto;}
.programDesc:after{visibility: hidden;
	display: block;
	content: &quot;&quot;;
	clear: both;
	height: 0;}
.programContent{float:right;width:85%;}


.via-slds .slds-radio .slds-radio--faux
{ border: 2px solid #49739c; }

.via-slds .slds-checkbox .slds-checkbox--faux
{ border: 2px solid #49739c; }

.vlocity ng-form{
    min-height: 1px !important;
}

ng-form.demo-short {
    min-height: 1em !important;
}

&lt;/style&gt;


&lt;script type=&quot;text/ng-template&quot; id=&quot;demoDataButton&quot;&gt;
 &lt;div class=&quot;slds-col--padded slds-size--1-of-1 ng-scope&quot;&gt;
   &lt;ng-form name=&quot;loopform&quot;
     class=&quot;slds-form-element vlc-flex vlc-form-group vlc-slds-remote-action--button ng-pristine ng-valid ng-scope demo-short&quot;
     ng-repeat=&quot;control in child.eleArray&quot;&gt;
       &lt;div class=&quot;slds-form-element__control&quot;&gt;
         &lt;div class=&quot;vlc-control-wrapper&quot;&gt;
           &lt;div  id=&apos;{{::control.name}}&apos;
                 class=&quot;vlc-slds-button--tertiary ng-binding ng-scope&quot;
                 title=&apos;{{::control.propSetMap.label}}&apos;
                 ng-click=&quot;buttonClick(this.bpTree.response, control, this)&quot;
                 style=&quot;font-style: italic; font-size: smaller; cursor: pointer; text-align: right;&quot;&gt;{{::control.propSetMap.label}}&lt;/div&gt;
         &lt;/div&gt;
       &lt;div class=&quot;vlc-sub-block&quot;&gt;&lt;/div&gt;
     &lt;/div&gt;
   &lt;/ng-form&gt;
 &lt;/div&gt;
&lt;/script&gt;</customHtmlTemplates>
    <description>Integrated Eligibility example with applicant submitting a request for 3 programs at once. Uses Google Maps Alternative</description>
    <elementTypeComponentMapping>{&quot;ElementTypeToHTMLTemplateList&quot;:[]}</elementTypeComponentMapping>
    <isActive>false</isActive>
    <isIntegrationProcedure>false</isIntegrationProcedure>
    <isManagedUsingStdDesigner>false</isManagedUsingStdDesigner>
    <isMetadataCacheDisabled>false</isMetadataCacheDisabled>
    <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
    <isTestProcedure>false</isTestProcedure>
    <isWebCompEnabled>true</isWebCompEnabled>
    <language>English</language>
    <name>Children with Disabilities Family Support</name>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>CreateIEReferrals</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;controlWidth&quot; : 12,
  &quot;label&quot; : &quot;CreateIEReferrals&quot;,
  &quot;integrationProcedureKey&quot; : &quot;HHS_Referrals&quot;,
  &quot;useContinuation&quot; : false,
  &quot;remoteOptions&quot; : {
    &quot;preTransformBundle&quot; : &quot;&quot;,
    &quot;postTransformBundle&quot; : &quot;&quot;,
    &quot;useFuture&quot; : false,
    &quot;chainable&quot; : false
  },
  &quot;remoteTimeout&quot; : 30000,
  &quot;preTransformBundle&quot; : &quot;&quot;,
  &quot;postTransformBundle&quot; : &quot;&quot;,
  &quot;sendJSONPath&quot; : &quot;&quot;,
  &quot;sendJSONNode&quot; : &quot;&quot;,
  &quot;responseJSONPath&quot; : &quot;&quot;,
  &quot;responseJSONNode&quot; : &quot;&quot;,
  &quot;extraPayload&quot; : { },
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureGoBackLabel&quot; : &quot;Go Back&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3,
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;Yes&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;
      } ]
    }
  },
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;svgSprite&quot; : &quot;&quot;,
  &quot;svgIcon&quot; : &quot;&quot;,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : null
  },
  &quot;enableDefaultAbort&quot; : false,
  &quot;enableActionMessage&quot; : false,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>12.0</sequenceNumber>
        <type>Integration Procedure Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Accesstobenefits</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Do you authorize the person named to access to your benefits on your EBT Card?&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;horizontalMode&quot; : true,
  &quot;help&quot; : false,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Yes&quot;,
    &quot;value&quot; : &quot;Yes&quot;
  }, {
    &quot;name&quot; : &quot;No&quot;,
    &quot;value&quot; : &quot;No&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false
}</propertySetConfig>
                <sequenceNumber>6.0</sequenceNumber>
                <type>Radio</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>AgencyOrg</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 6.0,
  &quot;label&quot; : &quot;Agency or Organization (If Applicable)&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Assistant First</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;First Name&quot;,
  &quot;controlWidth&quot; : 3.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>AssistantEmail</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Email&quot;,
  &quot;controlWidth&quot; : 3.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0
}</propertySetConfig>
                <sequenceNumber>4.0</sequenceNumber>
                <type>Email</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>AssistantLast</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Last Name&quot;,
  &quot;controlWidth&quot; : 3.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0
}</propertySetConfig>
                <sequenceNumber>3.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>AssistantPhone</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Phone&quot;,
  &quot;controlWidth&quot; : 3.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;mask&quot; : &quot;(999) 999-9999&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0
}</propertySetConfig>
                <sequenceNumber>5.0</sequenceNumber>
                <type>Telephone</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Text1</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;debounceValue&quot; : 0.0,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255.0,
  &quot;minLength&quot; : 0.0,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;showInputWidth&quot; : false,
  &quot;label&quot; : &quot;Position&quot;,
  &quot;controlWidth&quot; : 6.0
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Authorized assistant</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;NeedAssistance&quot;,
        &quot;data&quot; : &quot;true&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Authorized assistant&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Communication Needs</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Do you have other communication needs such as braille, relay, large print, or TDD/TTY?&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;horizontalMode&quot; : true,
  &quot;help&quot; : false,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Braille&quot;,
    &quot;value&quot; : &quot;Braille&quot;
  }, {
    &quot;name&quot; : &quot;Signed English&quot;,
    &quot;value&quot; : &quot;Signed English&quot;
  }, {
    &quot;name&quot; : &quot;Large Print&quot;,
    &quot;value&quot; : &quot;Large Print&quot;
  }, {
    &quot;name&quot; : &quot;Relay&quot;,
    &quot;value&quot; : &quot;Relay&quot;
  }, {
    &quot;name&quot; : &quot;American Sign&quot;,
    &quot;value&quot; : &quot;American Sign&quot;
  }, {
    &quot;name&quot; : &quot;TDD/TTY&quot;,
    &quot;value&quot; : &quot;TDD/TTY&quot;
  }, {
    &quot;name&quot; : &quot;Other&quot;,
    &quot;value&quot; : &quot;Other&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;hide&quot; : false,
  &quot;optionWidth&quot; : 100.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;enableCaption&quot; : true,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>3.0</sequenceNumber>
                <type>Multi-select</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>LanguageSpoken</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Language Spoken&quot;,
  &quot;controlWidth&quot; : 8.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;horizontalMode&quot; : true,
  &quot;help&quot; : false,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;English&quot;,
    &quot;value&quot; : &quot;English&quot;
  }, {
    &quot;name&quot; : &quot;French&quot;,
    &quot;value&quot; : &quot;French&quot;
  }, {
    &quot;name&quot; : &quot;Other&quot;,
    &quot;value&quot; : &quot;Other&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;SObject&quot;,
    &quot;source&quot; : &quot;Referral.ClientLanguage&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;hide&quot; : false,
  &quot;optionWidth&quot; : 100.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;enableCaption&quot; : true,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Multi-select</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>OtherLang</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 6.0,
  &quot;label&quot; : &quot;Other Language&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;Other&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;LanguageSpoken&quot;
      }, {
        &quot;field&quot; : &quot;LanguageSpoken&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;English;Other&quot;
      }, {
        &quot;field&quot; : &quot;LanguageSpoken&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;English;French;Other&quot;
      }, {
        &quot;field&quot; : &quot;LanguageSpoken&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;French;Other&quot;
      } ]
    }
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>RequiresInterpreter</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Requires Interpreter&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;checkLabel&quot; : &quot;Requires Interpreter?&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Checkbox</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Communication</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Communication&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;collapse&quot; : false,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>17.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>DOB</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Date of birth&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;dateFormat&quot; : &quot;MM-dd-yyyy&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false
}</propertySetConfig>
            <sequenceNumber>12.0</sequenceNumber>
            <type>Date</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Email</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Email&quot;,
  &quot;controlWidth&quot; : 6.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0
}</propertySetConfig>
            <sequenceNumber>9.0</sequenceNumber>
            <type>Email</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>FirstName</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;First Name&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : true,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>Text</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Gender</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Gender&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Male&quot;,
    &quot;value&quot; : &quot;Male&quot;
  }, {
    &quot;name&quot; : &quot;Female&quot;,
    &quot;value&quot; : &quot;Female&quot;
  }, {
    &quot;name&quot; : &quot;Transgender&quot;,
    &quot;value&quot; : &quot;Transgender&quot;
  }, {
    &quot;name&quot; : &quot;Other&quot;,
    &quot;value&quot; : &quot;Other&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>14.0</sequenceNumber>
            <type>Select</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>City</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;City&quot;,
  &quot;controlWidth&quot; : 3.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Country</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Country&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false
}</propertySetConfig>
                <sequenceNumber>5.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>GoogleMapsAlternative</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;GoogleMapsAlternative&quot;,
  &quot;integrationProcedureKey&quot; : &quot;GoogleMapsTransformations_HHSIntegratedEligibility&quot;,
  &quot;useContinuation&quot; : false,
  &quot;remoteOptions&quot; : {
    &quot;preTransformBundle&quot; : &quot;&quot;,
    &quot;postTransformBundle&quot; : &quot;&quot;,
    &quot;useFuture&quot; : false,
    &quot;chainable&quot; : false
  },
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;preTransformBundle&quot; : &quot;&quot;,
  &quot;postTransformBundle&quot; : &quot;&quot;,
  &quot;sendJSONPath&quot; : &quot;&quot;,
  &quot;sendJSONNode&quot; : &quot;&quot;,
  &quot;responseJSONPath&quot; : &quot;GoogleSearchResults&quot;,
  &quot;responseJSONNode&quot; : &quot;&quot;,
  &quot;extraPayload&quot; : {
    &quot;SearchString&quot; : &quot;%HomeAddress%&quot;
  },
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureGoBackLabel&quot; : &quot;Go Back&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3.0,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3.0,
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;show&quot; : null,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;svgSprite&quot; : &quot;&quot;,
  &quot;svgIcon&quot; : &quot;&quot;,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : null
  },
  &quot;enableDefaultAbort&quot; : false,
  &quot;enableActionMessage&quot; : false,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;,
  &quot;sendOnlyExtraPayload&quot; : true
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Integration Procedure Action</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>State</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Province&quot;,
  &quot;controlWidth&quot; : 3.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;ON&quot;,
    &quot;value&quot; : &quot;Ontario&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;debounceValue&quot; : 0.0,
  &quot;hide&quot; : false,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>3.0</sequenceNumber>
                <type>Select</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Street</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Street Address&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;includeCustomization&quot; : true,
  &quot;persistentComponent&quot; : [ {
    &quot;render&quot; : false,
    &quot;label&quot; : &quot;&quot;,
    &quot;remoteClass&quot; : &quot;&quot;,
    &quot;remoteMethod&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0,
    &quot;remoteOptions&quot; : {
      &quot;preTransformBundle&quot; : &quot;&quot;,
      &quot;postTransformBundle&quot; : &quot;&quot;
    },
    &quot;preTransformBundle&quot; : &quot;&quot;,
    &quot;postTransformBundle&quot; : &quot;&quot;,
    &quot;sendJSONPath&quot; : &quot;&quot;,
    &quot;sendJSONNode&quot; : &quot;&quot;,
    &quot;responseJSONPath&quot; : &quot;&quot;,
    &quot;responseJSONNode&quot; : &quot;&quot;,
    &quot;id&quot; : &quot;vlcCart&quot;,
    &quot;itemsKey&quot; : &quot;cartItems&quot;,
    &quot;modalConfigurationSetting&quot; : {
      &quot;modalHTMLTemplateId&quot; : &quot;vlcProductConfig.html&quot;,
      &quot;modalController&quot; : &quot;ModalProductCtrl&quot;,
      &quot;modalSize&quot; : &quot;lg&quot;
    }
  }, {
    &quot;render&quot; : false,
    &quot;label&quot; : &quot;&quot;,
    &quot;remoteClass&quot; : &quot;&quot;,
    &quot;remoteMethod&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0,
    &quot;remoteOptions&quot; : {
      &quot;preTransformBundle&quot; : &quot;&quot;,
      &quot;postTransformBundle&quot; : &quot;&quot;
    },
    &quot;preTransformBundle&quot; : &quot;&quot;,
    &quot;postTransformBundle&quot; : &quot;&quot;,
    &quot;id&quot; : &quot;vlcKnowledge&quot;,
    &quot;itemsKey&quot; : &quot;knowledgeItems&quot;,
    &quot;modalConfigurationSetting&quot; : {
      &quot;modalHTMLTemplateId&quot; : &quot;&quot;,
      &quot;modalController&quot; : &quot;&quot;,
      &quot;modalSize&quot; : &quot;lg&quot;
    }
  } ],
  &quot;allowSaveForLater&quot; : true,
  &quot;saveForLaterRedirectPageName&quot; : &quot;sflRedirect&quot;,
  &quot;saveForLaterRedirectTemplateUrl&quot; : &quot;vlcSaveForLaterAcknowledge.html&quot;,
  &quot;saveContentEncoded&quot; : false,
  &quot;autoSaveOnStepNext&quot; : false,
  &quot;elementTypeToHTMLTemplateMapping&quot; : { },
  &quot;seedDataJSON&quot; : { },
  &quot;enableKnowledge&quot; : false,
  &quot;knowledgeArticleTypeQueryFieldsMap&quot; : { },
  &quot;timeTracking&quot; : true,
  &quot;hide&quot; : false
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>ZIPCode</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Postal Code&quot;,
  &quot;controlWidth&quot; : 2.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false
}</propertySetConfig>
                <sequenceNumber>4.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>HomeAddress</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Home Address&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;googleTransformation&quot; : {
    &quot;street&quot; : &quot;Street&quot;,
    &quot;locality&quot; : &quot;City&quot;,
    &quot;administrative_area_level_1&quot; : &quot;State&quot;,
    &quot;country&quot; : &quot;Country&quot;,
    &quot;postal_code&quot; : &quot;ZIPCode&quot;
  },
  &quot;required&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;typeAheadKey&quot; : &quot;Description&quot;,
  &quot;dataProcessorFunction&quot; : &quot;&quot;,
  &quot;callFrequency&quot; : 300.0,
  &quot;editMode&quot; : false,
  &quot;newItemLabel&quot; : &quot;&quot;,
  &quot;hideEditButton&quot; : false,
  &quot;enableGoogleMapsAutocomplete&quot; : false,
  &quot;googleMapsAPIKey&quot; : &quot;AIzaSyD02SueuLAFpiDuaHWCo32pIx9gTW4wtO4&quot;,
  &quot;hideMap&quot; : false,
  &quot;googleAddressCountry&quot; : &quot;ca&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;enableLookup&quot; : false,
  &quot;useDataJson&quot; : false,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>7.0</sequenceNumber>
            <type>Type Ahead Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>LastName</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Last Name&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : true,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>5.0</sequenceNumber>
            <type>Text</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>LineBreak2</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;LineBreak2&quot;,
  &quot;padding&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;
}</propertySetConfig>
            <sequenceNumber>13.0</sequenceNumber>
            <type>Line Break</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>MaritalStatus</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Marital Status&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Married&quot;,
    &quot;value&quot; : &quot;Married&quot;
  }, {
    &quot;name&quot; : &quot;Single&quot;,
    &quot;value&quot; : &quot;Single&quot;
  }, {
    &quot;name&quot; : &quot;Divorced&quot;,
    &quot;value&quot; : &quot;Divorced&quot;
  }, {
    &quot;name&quot; : &quot;Separated&quot;,
    &quot;value&quot; : &quot;Separated&quot;
  }, {
    &quot;name&quot; : &quot;Widowed&quot;,
    &quot;value&quot; : &quot;Widowed&quot;
  }, {
    &quot;name&quot; : &quot;Deserted&quot;,
    &quot;value&quot; : &quot;Deserted&quot;
  }, {
    &quot;name&quot; : &quot;Spousal&quot;,
    &quot;value&quot; : &quot;Spousal&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false
}</propertySetConfig>
            <sequenceNumber>16.0</sequenceNumber>
            <type>Select</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>MiddleName</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Middle Name&quot;,
  &quot;controlWidth&quot; : 3.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;elementValueMap&quot; : { },
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { }
}</propertySetConfig>
            <sequenceNumber>4.0</sequenceNumber>
            <type>Text</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>NeedAssistance</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;checkLabel&quot; : &quot;I want to name someone who will help me with this application.&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Checkbox</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>OtherGender</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 4.0,
  &quot;label&quot; : &quot;Other Gender - Please Specify:&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
            <sequenceNumber>15.0</sequenceNumber>
            <type>Text</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Phone</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Phone&quot;,
  &quot;controlWidth&quot; : 6.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;mask&quot; : &quot;(999) 999-9999&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0
}</propertySetConfig>
            <sequenceNumber>10.0</sequenceNumber>
            <type>Telephone</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SSN</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Social Security Number&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;mask&quot; : &quot;999-999-999&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
            <sequenceNumber>11.0</sequenceNumber>
            <type>Text</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SV-DemoData1</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;&gt;&gt;&gt;&quot;,
  &quot;controlWidth&quot; : 1,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;elementValueMap&quot; : {
    &quot;Communication&quot; : {
      &quot;RequiresInterpreter&quot; : false,
      &quot;LanguageSpoken&quot; : &quot;English&quot;
    },
    &quot;FamilyCaregiver&quot; : &quot;Yes&quot;,
    &quot;HomeAddress-Block&quot; : {
      &quot;HomeAddress&quot; : &quot;5216 Maple Street, Fairfax, VA&quot;,
      &quot;ZIPCode&quot; : &quot;22030&quot;,
      &quot;Country&quot; : &quot;United States&quot;,
      &quot;State&quot; : &quot;VA&quot;,
      &quot;City&quot; : &quot;Fairfax&quot;,
      &quot;Street&quot; : &quot;5216 Maple Street&quot;
    },
    &quot;Email&quot; : &quot;pmarshall@demo.com&quot;,
    &quot;Phone&quot; : &quot;2125558763&quot;,
    &quot;SSN&quot; : &quot;123456789&quot;,
    &quot;DOB&quot; : &quot;1975-08-01&quot;,
    &quot;MaritalStatus&quot; : &quot;Single&quot;,
    &quot;Gender&quot; : &quot;Male&quot;,
    &quot;FirstName&quot; : &quot;Paul&quot;,
    &quot;LastName&quot; : &quot;Marshall&quot;
  },
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
            <sequenceNumber>6.0</sequenceNumber>
            <type>Set Values</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Text Block 5</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;dataJSON&quot; : false
}</propertySetConfig>
            <sequenceNumber>8.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>TextBlock6</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock6&quot;,
  &quot;text&quot; : &quot;&lt;h2&gt;Primary Caregiver Details&lt;/h2&gt;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Demographics</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Applicant Details&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>3.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SupportingDocs</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;uploadContDoc&quot; : true,
  &quot;contentParentId&quot; : [ &quot;%DRId_Case%&quot; ],
  &quot;extraPayload&quot; : { },
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;,
  &quot;remoteOptions&quot; : { },
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ]
  }
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>File</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>TextBlock10</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock10&quot;,
  &quot;text&quot; : &quot;&lt;h3&gt;Please upload any additional Supporting Documentation as it relates to your application&lt;/h3&gt;\n&lt;p&gt;We require the following documentation:&lt;/p&gt;\n&lt;ol&gt;\n&lt;li&gt;Copy of your Canadian citizenship or immigration status in Canada (E.g. Canadian Birth Certificate OR if you were not born in Canada please provide a copy of your most recent immigration document)&lt;/li&gt;\n&lt;li class=\&quot;p1\&quot;&gt;Copy of your child&amp;rsquo;s health card&lt;/li&gt;\n&lt;li class=\&quot;p1\&quot;&gt;Copy of MEDICAL documentation that details your child&amp;rsquo;s disability or diagnosis, signed by a Physician or a Psychologist in Ontario (e.g. Psychological Assessment)&lt;/li&gt;\n&lt;li class=\&quot;p1\&quot;&gt;Copy of your Notice of Assessment (showing line 15000) for yourself (if single), or for you &amp;amp; your spouse (if married or in a common-law relationship even if $0 amount)&lt;/li&gt;\n&lt;li class=\&quot;p1\&quot;&gt;Copy of 2019 Canada Child Benefit (CCB) Notice for the period July 2020 &amp;ndash; June 2021. This document is mailed to you from Canada Revenue Agency in July each year. This document includes the name of your child/children and your marital status&lt;/li&gt;\n&lt;li class=\&quot;p1\&quot;&gt;Bank information or a void cheque for direct deposit&lt;/li&gt;\n&lt;/ol&gt;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Documentation</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Additional Documentation&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Submit&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>13.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>DR - Create Expenses</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;DR - Create Expenses&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;validationRequired&quot; : &quot;Submit&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3.0,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3.0,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;bundle&quot; : &quot;DRCreateExpenses&quot;
}</propertySetConfig>
        <sequenceNumber>10.0</sequenceNumber>
        <type>DataRaptor Post Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>DR - Create Income</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;Yes&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;DR - Create Income&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;validationRequired&quot; : &quot;Submit&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3.0,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3.0,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;bundle&quot; : &quot;DRIECreateIncome&quot;
}</propertySetConfig>
        <sequenceNumber>8.0</sequenceNumber>
        <type>DataRaptor Post Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>DR-GetCaseID</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;DR-GetCaseID&quot;,
  &quot;bundle&quot; : &quot;DRGetCaseID&quot;,
  &quot;ignoreCache&quot; : false,
  &quot;dataRaptor Input Parameters&quot; : [ {
    &quot;element&quot; : &quot;DRId_Case&quot;,
    &quot;inputParam&quot; : &quot;CaseId&quot;
  } ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;responseJSONPath&quot; : &quot;&quot;,
  &quot;responseJSONNode&quot; : &quot;&quot;,
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureGoBackLabel&quot; : &quot;Go Back&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3.0,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3.0,
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ]
  },
  &quot;enableDefaultAbort&quot; : false,
  &quot;enableActionMessage&quot; : false,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>6.0</sequenceNumber>
        <type>DataRaptor Extract Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>DRCreateCaseAndParticipants</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;DRCreateCaseAndParticipants&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;bundle&quot; : &quot;DRCreateCaseAndParticipants&quot;,
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;validationRequired&quot; : &quot;Submit&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3.0,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3.0,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { }
}</propertySetConfig>
        <sequenceNumber>5.0</sequenceNumber>
        <type>DataRaptor Post Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Amount</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Amount&quot;,
  &quot;controlWidth&quot; : 5.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;mask&quot; : 0.0,
  &quot;allowNegative&quot; : false,
  &quot;hideGroupSep&quot; : false,
  &quot;currencySymbol&quot; : &quot;$&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>3.0</sequenceNumber>
                <type>Currency</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Frequency</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 7.0,
  &quot;label&quot; : &quot;Frequency&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;options&quot; : [ ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;SObject&quot;,
    &quot;source&quot; : &quot;PartyIncome.IncomeFrequency&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Select</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>IncomeDetail</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Details&quot;,
  &quot;controlWidth&quot; : 6.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : true,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false,
  &quot;helpText&quot; : &quot;Ex. Employer, Type of Support Recieved, Other Income Type such as gifts or allowance, etc.&quot;
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Source</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 6.0,
  &quot;label&quot; : &quot;Income Type&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Employment&quot;,
    &quot;value&quot; : &quot;Employment Income&quot;
  }, {
    &quot;name&quot; : &quot;Investments&quot;,
    &quot;value&quot; : &quot;Investments&quot;
  }, {
    &quot;name&quot; : &quot;Unemployment&quot;,
    &quot;value&quot; : &quot;Unemployment Insurance&quot;
  }, {
    &quot;name&quot; : &quot;Disability&quot;,
    &quot;value&quot; : &quot;Disability Support&quot;
  }, {
    &quot;name&quot; : &quot;Other&quot;,
    &quot;value&quot; : &quot;Other&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;SObject&quot;,
    &quot;source&quot; : &quot;PartyIncome.IncomeType&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Select</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>IncomeBlock</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Income&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;repeat&quot; : true,
  &quot;repeatClone&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ProofOfIncome</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Please upload any proof of income (ex. Paystubs)&quot;,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;uploadContDoc&quot; : true,
  &quot;contentParentId&quot; : [ &quot;%DRId_Case%&quot; ],
  &quot;extraPayload&quot; : { },
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;,
  &quot;remoteOptions&quot; : { },
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ]
  }
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>File</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SV-DemoData3</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;&gt;&gt;&gt;&quot;,
  &quot;disOnTplt&quot; : false,
  &quot;controlWidth&quot; : 1.0,
  &quot;validationRequired&quot; : &quot;None&quot;,
  &quot;elementValueMap&quot; : {
    &quot;Employment Income&quot; : {
      &quot;IncomeBlock&quot; : [ {
        &quot;Source&quot; : &quot;Salary&quot;,
        &quot;IncomeDetail&quot; : &quot;Subway&quot;,
        &quot;Frequency&quot; : &quot;Weekly&quot;,
        &quot;Amount&quot; : 200.0
      }, {
        &quot;Source&quot; : &quot;Salary&quot;,
        &quot;IncomeDetail&quot; : &quot;Uber&quot;,
        &quot;Frequency&quot; : &quot;Monthly&quot;,
        &quot;Amount&quot; : 220.0
      } ]
    }
  },
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { }
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>Set Values</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>TextBlock3</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock3&quot;,
  &quot;text&quot; : &quot;&lt;p&gt;Please enter details of all your current sources of income, for your entire household. You can click on the \&quot;Add\&quot; button on the right to provide additional sources of income.&lt;/p&gt;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Employment Income</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Income Details&quot;,
  &quot;validationRequired&quot; : &quot;&lt;p&gt;true&lt;/p&gt;&quot;,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;elementValueMap&quot; : { },
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { }
}</propertySetConfig>
        <sequenceNumber>7.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Benefits Report Footer</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;text&quot; : &quot;&lt;h2&gt;Please note that this is &lt;span style=\&quot;text-decoration: underline;\&quot;&gt;&lt;strong&gt;only an estimate&lt;/strong&gt;&lt;/span&gt;. Your actual benefit (if any) will only be determined after all of your information has been documented and verified.&lt;/h2&gt;\n&lt;p&gt;&amp;nbsp;&lt;/p&gt;&quot;
}</propertySetConfig>
            <sequenceNumber>4.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Benefits Report Header</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;text&quot; : &quot;&lt;h2&gt;%FirstName%, based on the information you have entered, your estimated benefits are:&lt;/h2&gt;&quot;,
  &quot;dataJSON&quot; : false
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Benefits Report SNAP</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;dataJSON&quot; : false,
  &quot;text&quot; : &quot;&lt;div class=\&quot;programDesc\&quot;&gt;&lt;img src=\&quot;/servlet/servlet.ImageServer?id=0154S0000009UTEQA2&amp;amp;docName=ACSD_Logo&amp;amp;oid=00D4S000000qU7w\&quot; alt=\&quot;ACSD-Logo\&quot; width=\&quot;125\&quot; height=\&quot;118\&quot; /&gt;&lt;br /&gt;\n&lt;div class=\&quot;programContent\&quot;&gt;\n&lt;h2&gt;Assistance for Children with Severe Disabilities (ACSD): &lt;strong&gt;&lt;span style=\&quot;color: #008000;\&quot;&gt;$317.50&lt;/span&gt;&lt;/strong&gt; per month&lt;/h2&gt;\n&lt;/div&gt;\n&lt;/div&gt;&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Benefits Report TANF</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;dataJSON&quot; : false,
  &quot;text&quot; : &quot;&lt;div class=\&quot;programDesc\&quot;&gt;&lt;img src=\&quot;/servlet/servlet.ImageServer?id=0154S0000009UTDQA2&amp;amp;docName=ER_Logo&amp;amp;oid=00D4S000000qU7w\&quot; alt=\&quot;ER-Logo\&quot; width=\&quot;119\&quot; height=\&quot;112\&quot; /&gt;&lt;br /&gt;\n&lt;div class=\&quot;programContent\&quot;&gt;\n&lt;h2&gt;Enhanced Respite (ER): &lt;span style=\&quot;color: #4bc076;\&quot;&gt;&lt;span style=\&quot;color: #008000;\&quot;&gt;&lt;strong&gt;$297.00&lt;/strong&gt;&lt;/span&gt;&amp;nbsp;&lt;/span&gt;per month&lt;/h2&gt;\n&lt;/div&gt;\n&lt;/div&gt;&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Benefits Report WIC</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;textKey&quot; : &quot;&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;text&quot; : &quot;&lt;div class=\&quot;programDesc\&quot;&gt;&lt;img src=\&quot;/servlet/servlet.ImageServer?id=0154S0000009UTFQA2&amp;amp;docName=SSAH_Logo&amp;amp;oid=00D4S000000qU7w\&quot; alt=\&quot;SSAH-Logo\&quot; width=\&quot;122\&quot; height=\&quot;113\&quot; /&gt;&lt;br /&gt;\n&lt;div class=\&quot;programContent\&quot;&gt;\n&lt;h2&gt;Special Services At Home (SSAH): &lt;strong&gt;&lt;span style=\&quot;color: #008000;\&quot;&gt;$277.50&lt;/span&gt;&lt;/strong&gt; per month&lt;/h2&gt;\n&lt;/div&gt;\n&lt;/div&gt;&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Estimated Benefits</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Estimated Benefits&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>11.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>LineBreak3</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;LineBreak3&quot;,
  &quot;padding&quot; : 12.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Line Break</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>TextBlock7</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock7&quot;,
  &quot;text&quot; : &quot;&lt;h4 class=\&quot;p1\&quot;&gt;Extraordinary Child Care and Babysitting Costs&lt;/h4&gt;\n&lt;p class=\&quot;p1\&quot;&gt;If the child does not require specialized childcare then no cost will be allowed.&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;&amp;nbsp;&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;&lt;strong&gt;Extraordinary Hourly Cost For Specialized Care&lt;/strong&gt;&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;If your child with special needs is 12 years of age or older and still requires a babysitter, childcare will be approved at cost.&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;&amp;nbsp;&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;&lt;strong&gt;Babysitting Costs&lt;/strong&gt;&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;The babysitting for other children in the family, less than 12 years of age, while taking the identified child to a doctor&apos;s appointment or meetings relating to the disability may be included.&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;&amp;nbsp;&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;&lt;strong&gt;Specialized Day Care&lt;/strong&gt;&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;Day care costs may be claimed when integration into a specific program has been recommended by a professional (recommendation and receipts are required).&lt;/p&gt;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Text Block</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>TextBlock9</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;sanitize&quot; : false,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;text&quot; : &quot;&lt;h4&gt;&lt;strong&gt;Transportation, Meals and Accomodation&lt;/strong&gt;&lt;/h4&gt;\n&lt;p class=\&quot;p1\&quot;&gt;Transportation and meal costs may be considered when the purpose of the trip is to escort the child to treatment or medical appointments related to the disability. Transportation costs paid to these appointments (e.g. car, bus, train, etc.) are allowable at actual cost. You will be reimbursed at $0.40 per kilometre for the use of a private car. Meals are allowable for the child and parent(s).&lt;/p&gt;\n&lt;p class=\&quot;p1\&quot;&gt;Please note that loss of pay as a result of having to take your child for treatment is not an eligible expense.&lt;/p&gt;&quot;,
  &quot;label&quot; : &quot;TextBlock5&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Text Block</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>DescriptionBlock</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Description of Expense Types&quot;,
  &quot;collapse&quot; : true,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeatLimit&quot; : null,
  &quot;show&quot; : null,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ExpenseReceipts</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;uploadContDoc&quot; : true,
  &quot;contentParentId&quot; : [ &quot;%DRId_Case%&quot; ],
  &quot;extraPayload&quot; : { },
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;,
  &quot;remoteOptions&quot; : { },
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ]
  }
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>File</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>ExpenseDetails</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;helpText&quot; : &quot;&quot;,
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;showInputWidth&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;maxLength&quot; : 255.0,
  &quot;minLength&quot; : 0.0,
  &quot;help&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;controlWidth&quot; : 6.0,
  &quot;label&quot; : &quot;Details&quot;
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>ExpenseType</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controllingField&quot; : {
    &quot;source&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;element&quot; : &quot;&quot;
  },
  &quot;optionSource&quot; : {
    &quot;source&quot; : &quot;Expense.Category__c&quot;,
    &quot;type&quot; : &quot;SObject&quot;
  },
  &quot;options&quot; : [ ],
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;showInputWidth&quot; : false,
  &quot;label&quot; : &quot;Expense Type&quot;,
  &quot;controlWidth&quot; : 6
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Select</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>MonthlyAmount</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;showInputWidth&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;currencySymbol&quot; : &quot;$&quot;,
  &quot;hideGroupSep&quot; : false,
  &quot;allowNegative&quot; : false,
  &quot;mask&quot; : 0.0,
  &quot;help&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;controlWidth&quot; : 6.0,
  &quot;label&quot; : &quot;Estimated Monthly Expense Amount&quot;
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Currency</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ExpensesBlock</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : true,
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Expenses&quot;
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SV-DemoData4</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;&gt;&gt;&gt;&quot;,
  &quot;disOnTplt&quot; : false,
  &quot;controlWidth&quot; : 1.0,
  &quot;validationRequired&quot; : &quot;None&quot;,
  &quot;elementValueMap&quot; : {
    &quot;ExpensesBlock&quot; : [ {
      &quot;ExpenseType&quot; : &quot;Transportation&quot;,
      &quot;ExpenseDetails&quot; : &quot;Taxi to Rehabilitation Centre&quot;,
      &quot;MonthlyAmount&quot; : 60.0
    }, {
      &quot;ExpenseType&quot; : &quot;Child Care &amp; Babysitting&quot;,
      &quot;ExpenseDetails&quot; : &quot;Specialized at-home day-care&quot;,
      &quot;MonthlyAmount&quot; : 2000.0
    }, {
      &quot;ExpenseType&quot; : &quot;Drug &amp; Medical&quot;,
      &quot;ExpenseDetails&quot; : &quot;Respiratory Medical Device and Oxygen Tank replacement&quot;,
      &quot;MonthlyAmount&quot; : 350.0
    }, {
      &quot;ExpenseType&quot; : &quot;Personal Care&quot;,
      &quot;ExpenseDetails&quot; : &quot;Physiotherapy&quot;,
      &quot;MonthlyAmount&quot; : 275.0
    } ]
  },
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { }
}</propertySetConfig>
            <sequenceNumber>4.0</sequenceNumber>
            <type>Set Values</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>TextBlock8</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock8&quot;,
  &quot;text&quot; : &quot;&lt;h3&gt;Supporting Documentation&lt;/h3&gt;\n&lt;p&gt;Please upload supporting documentation, such as receipts for your expenses here.&lt;/p&gt;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Household Expenses</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Expenses Report&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>9.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>DependantDOB</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 4.0,
  &quot;label&quot; : &quot;Date of Birth&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;dateType&quot; : &quot;string&quot;,
  &quot;modelDateFormat&quot; : &quot;yyyy-MM-dd&quot;,
  &quot;dateFormat&quot; : &quot;MM-dd-yyyy&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false,
  &quot;minDate&quot; : &quot;&quot;,
  &quot;maxDate&quot; : &quot;&quot;
}</propertySetConfig>
                <sequenceNumber>4.0</sequenceNumber>
                <type>Date</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>DependantFirst</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 4.0,
  &quot;label&quot; : &quot;First Name&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>DependantLast</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 4.0,
  &quot;label&quot; : &quot;Last Name&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>3.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>DependantMiddle</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;debounceValue&quot; : 0.0,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255.0,
  &quot;minLength&quot; : 0.0,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;showInputWidth&quot; : false,
  &quot;label&quot; : &quot;Middle Name&quot;,
  &quot;controlWidth&quot; : 4.0
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>HealthCard</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 5.0,
  &quot;label&quot; : &quot;Health Card Number (including version)&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>5.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Hospitalized</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Does the child spend any time in a hospital/institution? Please provide details.&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>7.0</sequenceNumber>
                <type>Text Area</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Sex</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 3.0,
  &quot;label&quot; : &quot;Sex&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Male&quot;,
    &quot;value&quot; : &quot;Male&quot;
  }, {
    &quot;name&quot; : &quot;Female&quot;,
    &quot;value&quot; : &quot;Female&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>6.0</sequenceNumber>
                <type>Select</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>TextBlock1</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock1&quot;,
  &quot;text&quot; : &quot;&lt;p&gt;Please enter the details of the dependant child for whom you are seeking support.&lt;/p&gt;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Text Block</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>DependantChild</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Dependant Child&quot;,
  &quot;collapse&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>OtherChildAge</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 2.0,
  &quot;label&quot; : &quot;Age&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>3.0</sequenceNumber>
                <type>Number</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>OtherChildFirst</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;First Name&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>OtherChildLast</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Last Name&quot;,
  &quot;controlWidth&quot; : 4.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>OtherChildSex</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;label&quot; : &quot;Sex&quot;,
  &quot;controlWidth&quot; : 2.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Male&quot;,
    &quot;value&quot; : &quot;Male&quot;
  }, {
    &quot;name&quot; : &quot;Female&quot;,
    &quot;value&quot; : &quot;Female&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>4.0</sequenceNumber>
                <type>Select</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>TextBlock2</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock2&quot;,
  &quot;text&quot; : &quot;&lt;p&gt;Please enter details of all other children in your household for whom you are the parent or legal guardian. Click the \&quot;Add\&quot;&amp;nbsp; button on the right to add more children.&lt;/p&gt;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Text Block</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>OtherChildren</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Other Children&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;repeat&quot; : true,
  &quot;repeatClone&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;collapse&quot; : false,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SetHouseholdValues</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 1,
  &quot;label&quot; : &quot;&gt;&gt;&gt;&quot;,
  &quot;elementValueMap&quot; : {
    &quot;DependantChild&quot; : {
      &quot;DependantFirst&quot; : &quot;Johnny&quot;,
      &quot;DependantLast&quot; : &quot;Marshall&quot;,
      &quot;HealthCard&quot; : &quot;123456789-NP&quot;,
      &quot;Sex&quot; : &quot;Male&quot;,
      &quot;DependantDOB&quot; : &quot;2009-01-01&quot;
    },
    &quot;OtherChildren&quot; : {
      &quot;OtherChildFirst&quot; : &quot;Allie&quot;,
      &quot;OtherChildLast&quot; : &quot;Marshall&quot;,
      &quot;OtherChildSex&quot; : &quot;Female&quot;,
      &quot;OtherChildAge&quot; : &quot;2&quot;
    }
  },
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>Set Values</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>SpousalConsent</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Checkbox1&quot;,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;defaultValue&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;checkLabel&quot; : &quot;Do you consent to discussing the details of this application/benefit with your spouse?&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>5.0</sequenceNumber>
                <type>Checkbox</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>SpouseDOB</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 4.0,
  &quot;label&quot; : &quot;Date of Birth&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;dateType&quot; : &quot;string&quot;,
  &quot;modelDateFormat&quot; : &quot;yyyy-MM-dd&quot;,
  &quot;dateFormat&quot; : &quot;MM-dd-yyyy&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false,
  &quot;minDate&quot; : &quot;&quot;,
  &quot;maxDate&quot; : &quot;&quot;
}</propertySetConfig>
                <sequenceNumber>4.0</sequenceNumber>
                <type>Date</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>SpouseFirst</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 4.0,
  &quot;label&quot; : &quot;First Name&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>SpouseMiddle</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;debounceValue&quot; : 0.0,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255.0,
  &quot;minLength&quot; : 0.0,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;showInputWidth&quot; : false,
  &quot;label&quot; : &quot;Middle Name&quot;,
  &quot;controlWidth&quot; : 4.0
}</propertySetConfig>
                <sequenceNumber>1.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>SpouseSIN</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;debounceValue&quot; : 0.0,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255.0,
  &quot;minLength&quot; : 0.0,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;showInputWidth&quot; : false,
  &quot;label&quot; : &quot;Social Insurance Number&quot;,
  &quot;controlWidth&quot; : 4.0
}</propertySetConfig>
                <sequenceNumber>3.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>Text4</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 4.0,
  &quot;label&quot; : &quot;Last Name&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12.0,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0.0,
  &quot;maxLength&quot; : 255.0,
  &quot;placeholder&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0.0,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
                <sequenceNumber>2.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SpousalInfoBlock</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Spousal Information&quot;,
  &quot;collapse&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;Married&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;MaritalStatus&quot;
      }, {
        &quot;field&quot; : &quot;MaritalStatus&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;Spousal&quot;
      } ]
    }
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>HouseholdDetails</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Household Details&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>4.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>NavigateAction1</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;NavigateAction1&quot;,
  &quot;validationRequired&quot; : &quot;Submit&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;pubsub&quot; : false,
  &quot;message&quot; : { },
  &quot;targetType&quot; : &quot;Record&quot;,
  &quot;objectAction&quot; : &quot;home&quot;,
  &quot;recordAction&quot; : &quot;view&quot;,
  &quot;loginAction&quot; : &quot;login&quot;,
  &quot;targetFilter&quot; : &quot;Recent&quot;,
  &quot;targetId&quot; : &quot;%DRId_Case%&quot;,
  &quot;variant&quot; : &quot;brand&quot;,
  &quot;iconName&quot; : &quot;&quot;,
  &quot;iconVariant&quot; : &quot;&quot;,
  &quot;iconPosition&quot; : &quot;left&quot;,
  &quot;replace&quot; : false,
  &quot;targetLWCLayout&quot; : &quot;lightning&quot;,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;,
  &quot;targetName&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>15.0</sequenceNumber>
        <type>Navigate Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Not Eligible Details</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;text&quot; : &quot;&lt;h2 style=\&quot;text-align: center;\&quot;&gt;Based on your responses your household is&amp;nbsp;not eligible for benefits.&lt;/h2&gt;\n&lt;h2 style=\&quot;text-align: center;\&quot;&gt;If the structure of your household changes such that you can truthfully provide different answers, please reapply.&lt;/h2&gt;&quot;,
  &quot;dataJSON&quot; : false
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>NotEligibleStep</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;No&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Eligibility Determination&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>2.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ACSD</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Apply for this Program?&quot;,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeatLimit&quot; : null,
  &quot;readOnly&quot; : false,
  &quot;horizontalMode&quot; : &quot;displayWide&quot;,
  &quot;defaultValue&quot; : null,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;helpTextPos&quot; : &quot;&quot;,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;true&quot;,
    &quot;developerName&quot; : null,
    &quot;value&quot; : &quot;Yes&quot;,
    &quot;autoAdv&quot; : null
  }, {
    &quot;name&quot; : &quot;false&quot;,
    &quot;developerName&quot; : null,
    &quot;value&quot; : &quot;No&quot;,
    &quot;autoAdv&quot; : null
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;show&quot; : null,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;optionWidth&quot; : 100.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;imageCountInRow&quot; : 3.0,
  &quot;enableCaption&quot; : true,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>Radio</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ACSD-Explanation</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;dataJSON&quot; : false,
  &quot;text&quot; : &quot;&lt;div class=\&quot;programDesc\&quot;&gt;&lt;img src=\&quot;/resource/ACSD\&quot; alt=\&quot;ACSD-Logo\&quot; width=\&quot;148\&quot; height=\&quot;140\&quot; /&gt;&lt;br /&gt;\n&lt;div class=\&quot;programContent\&quot;&gt;\n&lt;p&gt;If you are a parent or guardian who is caring for a child with a severe disability you may be able to get financial support through the Assistance for Children with Severe Disabilities (ACSD) Program. This program provides financial support for low-income and moderate-income families to cover some of the extra costs of caring for a child who has a severe disability.&lt;/p&gt;\n&lt;p&gt;Eligible parents and guardians can receive between $25 and $500 a month to help with disability-related costs.&lt;/p&gt;\n&lt;p&gt;&amp;nbsp;&lt;/p&gt;\n&lt;h4&gt;Eligibility&lt;/h4&gt;\n&lt;p&gt;If you are a parent or a guardian of a child who is under 18 years of age (17 and under), lives at home and who has a severe disability, you may be eligible to receive funding from this program.&lt;/p&gt;\n&lt;p&gt;Your eligibility and the amount of assistance you receive is based on a combination of factors:&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;your household income&lt;/li&gt;\n&lt;li&gt;size of your family&lt;/li&gt;\n&lt;li&gt;severity of your child&amp;rsquo;s disability&lt;/li&gt;\n&lt;li&gt;extraordinary costs related to your child&amp;rsquo;s disability&lt;/li&gt;\n&lt;/ul&gt;\n&lt;/div&gt;\n&lt;/div&gt;&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ER</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Apply for this Program?&quot;,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeatLimit&quot; : null,
  &quot;readOnly&quot; : false,
  &quot;horizontalMode&quot; : &quot;displayWide&quot;,
  &quot;defaultValue&quot; : null,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;helpTextPos&quot; : &quot;&quot;,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;true&quot;,
    &quot;developerName&quot; : null,
    &quot;value&quot; : &quot;Yes&quot;,
    &quot;autoAdv&quot; : null
  }, {
    &quot;name&quot; : &quot;false&quot;,
    &quot;developerName&quot; : null,
    &quot;value&quot; : &quot;No&quot;,
    &quot;autoAdv&quot; : null
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;show&quot; : null,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;optionWidth&quot; : 100.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;imageCountInRow&quot; : 3.0,
  &quot;enableCaption&quot; : true,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
            <sequenceNumber>10.0</sequenceNumber>
            <type>Radio</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ER-Explanation</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;dataJSON&quot; : false,
  &quot;text&quot; : &quot;&lt;div class=\&quot;programDesc\&quot;&gt;&lt;img src=\&quot;/resource/ER\&quot; alt=\&quot;ER-Logo\&quot; width=\&quot;145\&quot; height=\&quot;136\&quot; /&gt;&lt;br /&gt;\n&lt;div class=\&quot;programContent\&quot;&gt;\n&lt;p&gt;You can receive up to $3,500 per child, per year to spend on respite.&lt;/p&gt;\n&lt;p&gt;Your family may be eligible for this grant if you are caring for a child who is medically fragile and/or depends on a technological device and requires care 24 hours a day, 365 days a year.&lt;/p&gt;\n&lt;p&gt;&amp;nbsp;&lt;/p&gt;\n&lt;h4&gt;Eligibility&lt;/h4&gt;\n&lt;p&gt;To be eligible, your child must:&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;be under 18 years of age&lt;/li&gt;\n&lt;li&gt;live at home&lt;/li&gt;\n&lt;li&gt;need intensive care and constant monitoring on a 24-hour basis&lt;/li&gt;\n&lt;li&gt;be medically fragile and/or technology dependent, meeting one of the following criteria:\n&lt;ul&gt;\n&lt;li&gt;relies on medical and technological equipment, such as mechanical ventilators, apnea monitors, renal dialysis, urinary catheters, colostomy bags&lt;/li&gt;\n&lt;li&gt;is administered drugs intravenously&lt;/li&gt;\n&lt;li&gt;relies on tracheotomy tube care, suctioning, oxygen support or tube feeding&lt;/li&gt;\n&lt;/ul&gt;\n&lt;/li&gt;\n&lt;/ul&gt;\n&lt;/div&gt;\n&lt;/div&gt;&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>11.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>LineBreak5</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;LineBreak5&quot;,
  &quot;padding&quot; : 20.0,
  &quot;show&quot; : null,
  &quot;HTMLTemplateId&quot; : &quot;&quot;
}</propertySetConfig>
            <sequenceNumber>4.0</sequenceNumber>
            <type>Line Break</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>LineBreak6</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;show&quot; : null,
  &quot;padding&quot; : 20.0,
  &quot;label&quot; : &quot;LineBreak5&quot;
}</propertySetConfig>
            <sequenceNumber>8.0</sequenceNumber>
            <type>Line Break</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SSAH</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;enableCaption&quot; : true,
  &quot;imageCountInRow&quot; : 3.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;optionWidth&quot; : 100.0,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;show&quot; : null,
  &quot;controllingField&quot; : {
    &quot;source&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;element&quot; : &quot;&quot;
  },
  &quot;optionSource&quot; : {
    &quot;source&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;
  },
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;true&quot;,
    &quot;developerName&quot; : null,
    &quot;value&quot; : &quot;Yes&quot;,
    &quot;autoAdv&quot; : null
  }, {
    &quot;name&quot; : &quot;false&quot;,
    &quot;developerName&quot; : null,
    &quot;value&quot; : &quot;No&quot;,
    &quot;autoAdv&quot; : null
  } ],
  &quot;helpTextPos&quot; : &quot;&quot;,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;defaultValue&quot; : null,
  &quot;horizontalMode&quot; : &quot;displayWide&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeatLimit&quot; : null,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;label&quot; : &quot;Apply for this Program?&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>6.0</sequenceNumber>
            <type>Radio</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SSAH-Explanation</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;dataJSON&quot; : false,
  &quot;text&quot; : &quot;&lt;div class=\&quot;programDesc\&quot;&gt;&lt;img src=\&quot;/resource/SSAH\&quot; alt=\&quot;SSAH-Logo\&quot; width=\&quot;148\&quot; height=\&quot;138\&quot; /&gt;&lt;br /&gt;\n&lt;div class=\&quot;programContent\&quot;&gt;\n&lt;p&gt;Families who are caring for a child with a developmental and/or physical disability can apply to the special services at home program to get funding for primary caregiver relief and related supports or for activities of personal growth or development including camps and recreational activities, like swimming and music classes.&lt;/p&gt;\n&lt;p&gt;Respite enhances the primary caregiver&amp;rsquo;s capacity to provide care for the child with a disability living at home through the provision of indirect assistance. Indirect assistance can help provide relief to the primary caregiver so that they may take some time away from caregiving, or from one or more of their other responsibilities such as cooking, housekeeping and grocery shopping.&lt;/p&gt;\n&lt;p&gt;The amount of funding you receive depends on&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;the type and amount of service your child needs&lt;/li&gt;\n&lt;li&gt;what other help is available in your community&lt;/li&gt;\n&lt;li&gt;what kind of support you already receive&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&amp;nbsp;&lt;/p&gt;\n&lt;h4&gt;Eligibility&lt;/h4&gt;\n&lt;p&gt;You can apply for this support if your child:&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;has a developmental and/or physical disability&lt;/li&gt;\n&lt;li&gt;lives in Ontario&lt;/li&gt;\n&lt;li&gt;is under the age of 18&lt;/li&gt;\n&lt;li&gt;needs more support than you can provide&lt;/li&gt;\n&lt;li&gt;lives at home with you, or is not living at home with you and is not being helped by other residential services&lt;/li&gt;\n&lt;/ul&gt;\n&lt;/div&gt;\n&lt;/div&gt;&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>7.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>TextBlock11</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock11&quot;,
  &quot;text&quot; : &quot;&lt;h3&gt;Assistance for Children with Severe Disabilities Program&lt;/h3&gt;&quot;,
  &quot;show&quot; : null,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>TextBlock12</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;sanitize&quot; : false,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;dataJSON&quot; : false,
  &quot;show&quot; : null,
  &quot;text&quot; : &quot;&lt;h3&gt;Special Services at Home Program&lt;/h3&gt;&quot;,
  &quot;label&quot; : &quot;TextBlock11&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>5.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>TextBlock13</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;TextBlock11&quot;,
  &quot;text&quot; : &quot;&lt;h3&gt;Enhanced Respite Program&lt;/h3&gt;&quot;,
  &quot;show&quot; : null,
  &quot;dataJSON&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;textKey&quot; : &quot;&quot;,
  &quot;sanitize&quot; : false
}</propertySetConfig>
            <sequenceNumber>9.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Programs</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;label&quot; : &quot;About Our Programs&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;instruction&quot; : &quot;&lt;h1&gt;&amp;nbsp;&lt;/h1&gt;&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>0.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>HaveDisability</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Does the child you are supporting live with a disability?&quot;,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;horizontalMode&quot; : true,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Yes&quot;,
    &quot;value&quot; : &quot;Yes&quot;
  }, {
    &quot;name&quot; : &quot;No&quot;,
    &quot;value&quot; : &quot;No&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;optionWidth&quot; : 100.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;imageCountInRow&quot; : 3.0,
  &quot;enableCaption&quot; : true,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>Radio</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>IntensiveCare</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;enableCaption&quot; : true,
  &quot;imageCountInRow&quot; : 3.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;optionWidth&quot; : 100.0,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controllingField&quot; : {
    &quot;source&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;element&quot; : &quot;&quot;
  },
  &quot;optionSource&quot; : {
    &quot;source&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;
  },
  &quot;options&quot; : [ {
    &quot;value&quot; : &quot;Yes&quot;,
    &quot;name&quot; : &quot;Yes&quot;
  }, {
    &quot;value&quot; : &quot;No&quot;,
    &quot;name&quot; : &quot;No&quot;
  } ],
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;horizontalMode&quot; : true,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;label&quot; : &quot;Does the child you are supporting require intensive care and constant monitoring on a 24-hr basis?&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>Radio</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>OntarioResident</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;label&quot; : &quot;Are you a resident of Ontario?&quot;,
  &quot;required&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;horizontalMode&quot; : true,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;options&quot; : [ {
    &quot;name&quot; : &quot;Yes&quot;,
    &quot;value&quot; : &quot;Yes&quot;
  }, {
    &quot;name&quot; : &quot;No&quot;,
    &quot;value&quot; : &quot;No&quot;
  } ],
  &quot;optionSource&quot; : {
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;controllingField&quot; : {
    &quot;element&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;source&quot; : &quot;&quot;
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;optionWidth&quot; : 100.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;imageCountInRow&quot; : 3.0,
  &quot;enableCaption&quot; : true,
  &quot;disOnTplt&quot; : false
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Radio</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>PassesScreening</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;label&quot; : &quot;Passes Screening&quot;,
  &quot;controlWidth&quot; : 12.0,
  &quot;expression&quot; : &quot;IF(\n((%OntarioResident% &lt;&gt; &apos;Yes&apos;)||\n(%Under18% &lt;&gt; &apos;Yes&apos;)||\n(%HaveDisability% &lt;&gt; &apos;Yes&apos;)||\n(%IntensiveCare% &lt;&gt; &apos;Yes&apos;))\n,\n\&quot;No\&quot;,\n\&quot;Yes\&quot;\n)&quot;,
  &quot;hide&quot; : true,
  &quot;hideGroupSep&quot; : false,
  &quot;currencySymbol&quot; : &quot;$&quot;,
  &quot;dateFormat&quot; : &quot;MM-dd-yyyy&quot;
}</propertySetConfig>
            <sequenceNumber>4.0</sequenceNumber>
            <type>Formula</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Under18</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;disOnTplt&quot; : false,
  &quot;enableCaption&quot; : true,
  &quot;imageCountInRow&quot; : 3.0,
  &quot;optionHeight&quot; : 100.0,
  &quot;optionWidth&quot; : 100.0,
  &quot;hide&quot; : false,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controllingField&quot; : {
    &quot;source&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;,
    &quot;element&quot; : &quot;&quot;
  },
  &quot;optionSource&quot; : {
    &quot;source&quot; : &quot;&quot;,
    &quot;type&quot; : &quot;&quot;
  },
  &quot;options&quot; : [ {
    &quot;value&quot; : &quot;Yes&quot;,
    &quot;name&quot; : &quot;Yes&quot;
  }, {
    &quot;value&quot; : &quot;No&quot;,
    &quot;name&quot; : &quot;No&quot;
  } ],
  &quot;helpText&quot; : &quot;&quot;,
  &quot;help&quot; : false,
  &quot;horizontalMode&quot; : true,
  &quot;readOnly&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeat&quot; : false,
  &quot;required&quot; : false,
  &quot;label&quot; : &quot;Is the child you are supporting under the age of 18 (i.e. 17 or under)&quot;,
  &quot;controlWidth&quot; : 12.0
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Radio</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Self Disclosure</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;label&quot; : &quot;Self Disclosure&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>1.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>Thank you text</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12.0,
  &quot;text&quot; : &quot;&lt;h2 style=\&quot;text-align: center;\&quot;&gt;&lt;strong&gt;Thank you for completing the integrated eligibility application.&lt;/strong&gt;&lt;/h2&gt;\n&lt;h2 style=\&quot;text-align: center;\&quot;&gt;&lt;strong&gt;Your application number is &lt;span style=\&quot;color: #ff0000;\&quot;&gt;%CaseNumber%&lt;/span&gt;&lt;/strong&gt;&lt;/h2&gt;\n&lt;p&gt;&amp;nbsp;&lt;/p&gt;\n&lt;h3&gt;We will begin to review your information within the next three business days and will contact you to schedule an expedited in-person appointment at one of our screening centers &lt;strong&gt;within 5 business days&lt;/strong&gt;.&lt;/h3&gt;\n&lt;p&gt;&lt;/p&gt;&quot;,
  &quot;dataJSON&quot; : false
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Text Block</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>Thank you</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;PassesScreening&quot;,
        &quot;data&quot; : &quot;Yes&quot;
      } ]
    }
  },
  &quot;label&quot; : &quot;Thank you&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3.0,
  &quot;nextLabel&quot; : &quot;View&quot;,
  &quot;nextWidth&quot; : 3.0,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;remoteTimeout&quot; : 30000.0,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000.0
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;instruction&quot; : &quot;&quot;,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>14.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessType>OmniScript</omniProcessType>
    <propertySetConfig>{&quot;persistentComponent&quot;:[{&quot;render&quot;:false,&quot;label&quot;:&quot;&quot;,&quot;remoteClass&quot;:&quot;&quot;,&quot;remoteMethod&quot;:&quot;&quot;,&quot;remoteTimeout&quot;:30000,&quot;remoteOptions&quot;:{&quot;preTransformBundle&quot;:&quot;&quot;,&quot;postTransformBundle&quot;:&quot;&quot;},&quot;preTransformBundle&quot;:&quot;&quot;,&quot;postTransformBundle&quot;:&quot;&quot;,&quot;sendJSONPath&quot;:&quot;&quot;,&quot;sendJSONNode&quot;:&quot;&quot;,&quot;responseJSONPath&quot;:&quot;&quot;,&quot;responseJSONNode&quot;:&quot;&quot;,&quot;id&quot;:&quot;vlcCart&quot;,&quot;itemsKey&quot;:&quot;cartItems&quot;,&quot;modalConfigurationSetting&quot;:{&quot;modalHTMLTemplateId&quot;:&quot;vlcProductConfig.html&quot;,&quot;modalController&quot;:&quot;ModalProductCtrl&quot;,&quot;modalSize&quot;:&quot;lg&quot;}},{&quot;render&quot;:false,&quot;label&quot;:&quot;&quot;,&quot;remoteClass&quot;:&quot;&quot;,&quot;remoteMethod&quot;:&quot;&quot;,&quot;remoteTimeout&quot;:30000,&quot;remoteOptions&quot;:{&quot;preTransformBundle&quot;:&quot;&quot;,&quot;postTransformBundle&quot;:&quot;&quot;},&quot;preTransformBundle&quot;:&quot;&quot;,&quot;postTransformBundle&quot;:&quot;&quot;,&quot;id&quot;:&quot;vlcKnowledge&quot;,&quot;itemsKey&quot;:&quot;knowledgeItems&quot;,&quot;modalConfigurationSetting&quot;:{&quot;modalHTMLTemplateId&quot;:&quot;&quot;,&quot;modalController&quot;:&quot;&quot;,&quot;modalSize&quot;:&quot;lg&quot;}}],&quot;allowSaveForLater&quot;:true,&quot;saveNameTemplate&quot;:&quot;Multi-Program Application&quot;,&quot;saveExpireInDays&quot;:null,&quot;saveForLaterRedirectPageName&quot;:&quot;sflRedirect&quot;,&quot;saveForLaterRedirectTemplateUrl&quot;:&quot;vlcSaveForLaterAcknowledge.html&quot;,&quot;saveContentEncoded&quot;:false,&quot;saveObjectId&quot;:&quot;%ContextId%&quot;,&quot;saveURLPatterns&quot;:{},&quot;autoSaveOnStepNext&quot;:false,&quot;elementTypeToHTMLTemplateMapping&quot;:{},&quot;seedDataJSON&quot;:{&quot;ACSD&quot;:true,&quot;SSAH&quot;:true,&quot;ER&quot;:true},&quot;trackingCustomData&quot;:{},&quot;enableKnowledge&quot;:false,&quot;bLK&quot;:false,&quot;lkObjName&quot;:null,&quot;knowledgeArticleTypeQueryFieldsMap&quot;:{},&quot;timeTracking&quot;:false,&quot;hideStepChart&quot;:false,&quot;visualforcePagesAvailableInPreview&quot;:{},&quot;cancelType&quot;:&quot;URL&quot;,&quot;allowCancel&quot;:true,&quot;cancelSource&quot;:&quot;/s&quot;,&quot;cancelRedirectPageName&quot;:&quot;OmniScriptCancelled&quot;,&quot;cancelRedirectTemplateUrl&quot;:&quot;vlcCancelled.html&quot;,&quot;consoleTabLabel&quot;:&quot;New&quot;,&quot;wpm&quot;:false,&quot;ssm&quot;:false,&quot;message&quot;:{},&quot;pubsub&quot;:false,&quot;autoFocus&quot;:false,&quot;currencyCode&quot;:&quot;&quot;,&quot;showInputWidth&quot;:true,&quot;rtpSeed&quot;:false,&quot;consoleTabTitle&quot;:null,&quot;consoleTabIcon&quot;:&quot;custom:custom18&quot;,&quot;errorMessage&quot;:{&quot;custom&quot;:[]},&quot;disableUnloadWarn&quot;:true,&quot;stylesheet&quot;:{&quot;newport&quot;:&quot;&quot;,&quot;newportRtl&quot;:&quot;&quot;,&quot;lightning&quot;:&quot;&quot;,&quot;lightningRtl&quot;:&quot;&quot;},&quot;includeCustomization&quot;:true,&quot;stepChartPlacement&quot;:&quot;right&quot;,&quot;currentLanguage&quot;:&quot;en_US&quot;}</propertySetConfig>
    <subType>IntegratedEligibility</subType>
    <type>HHS</type>
    <uniqueName>HHS_IntegratedEligibility_English_2</uniqueName>
    <versionNumber>2.0</versionNumber>
    <webComponentKey>ee69336d-dd81-5a6e-49aa-512619d1c105</webComponentKey>
</OmniScript>
