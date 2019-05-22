# Salesforce Connector Integration

The Salesforce connector allows you to work with records in Salesforce, a web-based service that allows organizations to manage contact relationship management (CRM) data. You can use the Salesforce connector to create, query, retrieve, update, and delete records in your organization's Salesforce data. The connector uses the Salesforce SOAP API to interact with Salesforce.

In this scenario we will demonstrate how easy it is to query Salesforce objects (Accounts) using WSO2 EI and the Salesforce connector.

![img](https://github.com/NatashaWso2/SA-Tutorials/blob/master/Split-Aggregate-Pattern/Resources/Split-Aggregate-Pattern.png)


## Packaging the artifacts into a CApp

* Open all the projects in the "Project" directory using the Developer Studio. You should have 3 projects in the workspace now : "SalesforceAPI", "SalesforceAPICompositeApplication", "SalesforceAPIConnectorExporter"

* Update your Salesforce credentials i.e. username and password in the "SalesforceConfig.xml" that is created in "SalesforceAPI/src/main/synapse-config/local-entries".

* First bundle all the artifacts in the workspace into a CApp (Composite Application). 
Refer: [https://docs.wso2.com/display/ADMIN44x/Packaging+Artifacts+into+Composite+Applications] (https://docs.wso2.com/display/ADMIN44x/Packaging+Artifacts+into+Composite+Applications)

* Then create a CAR (Composite Application Archive) file to deploy it from the management console
Refer: [https://docs.wso2.com/display/ADMIN44x/Packaging+Artifacts+into+Composite+Applications#PackagingArtifactsintoCompositeApplications-CreatingaCompositeApplicationArchive(CAR)file] (https://docs.wso2.com/display/ADMIN44x/Packaging+Artifacts+into+Composite+Applications#PackagingArtifactsintoCompositeApplications-CreatingaCompositeApplicationArchive(CAR)file)

## Curl command to invoke the API

Get details of all Salesforce accounts : curl -X GET http://localhost:8280/sfdc/accounts

Get details of a particluar Salesforce account from the account id: curl -X GET http://localhost:8280/sfdc/accounts/{id}
