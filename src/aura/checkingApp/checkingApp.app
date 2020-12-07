<aura:application extends="force:slds">
    <aura:attribute name="selectedLookUpContactRecord" type="sObject" default="{}"/>
    <aura:attribute name="selectedLookUpCaseRecord" type="sObject" default="{}"/>
    <c:customLookup objectAPIName="lead" IconName="standard:lead" selectedRecord="{!v.selectedLookUpContactRecord}" label="이름" selectedObject="Lead" selectObjects="Lead,Contact"/>
    <c:customLookup objectAPIName="case" IconName="standard:case" selectedRecord="{!v.selectedLookUpCaseRecord}" label="관련 레코드" selectedObject="Case" selectObjects="Case,Opportunity"/>
</aura:application>