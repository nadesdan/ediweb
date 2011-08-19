<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE circuit>

<circuit access="public">
	<fuseaction name="home">
	</fuseaction>
	
	<fuseaction name="import">
		<invoke object="application.fileActions" methodcall="readFile('#attributes.store#.edi')" returnvariable="fileContent" />
		<invoke object="application.ediParse" methodcall="parse(fileContent)" returnvariable="result" />
		<invoke object="application.ediImport" methodcall="import(result)" returnvariable="batchid"/>
		<invoke object="application.ediMap" methodcall="map()"/>
		<invoke object="application.fileActions" methodcall="renameFile('#attributes.store#.edi','#batchid#.#attributes.store#')"/>
        <invoke object="application.ediQuery" methodcall="qryEmail(1,batchid)" returnvariable="qry"/>          
        <invoke object="application.email" method="emailNewOrders">
        	<argument name="to" value="#application.emailto#"/>
            <argument name="cc" value="#application.emailcc#"/>
      		<argument name="qry" value="#qry#"/>
        </invoke>
		<invoke object="application.ediQuery" methodcall="isolateInt(batchid)"/> 
        <invoke object="application.ediQuery" methodcall="updateStatus(1,2)"/>      
		
        <!--<invoke object="application.ediQuery" methodcall="cancelInt(#batchid#)"/>-->
     </fuseaction>
    
    <fuseaction name="dump">
		<do action="v.dump" contentVariable="pageContent"/>
	</fuseaction>
    
    
    <fuseaction name="email">
        <invoke object="application.ediQuery" methodcall="qryEmail(#attributes.status#,#attributes.batchid#)" returnvariable="qry"/>        
        <invoke object="application.email" method="emailNewOrders">
      		<argument name="to" value="#application.emailto#"/>
            <argument name="cc" value="#application.emailcc#"/>
      		<argument name="qry" value="#qry#"/>
        </invoke>        
        <do action="main.menu"/>
	</fuseaction>
	
	<fuseaction name="createCSVFile">
    	<invoke object="application.fileActions" methodcall="deleteFile('1.csv')" returnvariable="fileDelete"/>
		<invoke object="application.createCsv" methodcall="create()" returnvariable="content" />
		<invoke object="application.fileActions" methodcall="writeFile('1.csv',content)"/>
        <do action="main.menu"/>
	</fuseaction>
	

	<fuseaction name="export">
		<invoke object="application.ediFlat" methodcall="invoice()" returnvariable="invContent"/>
		<invoke object="application.fileActions" methodcall="writeFile('inv.flt',invContent)"/>
		<invoke object="application.ediFlat" methodcall="cancel()" returnvariable="cnclContent" />
		<invoke object="application.fileActions" methodcall="writeFile('cncl.flt',cnclContent)"/>
	</fuseaction>	
	
	<fuseaction name="info">
		<invoke object="application.ediQuery" methodcall="qryItemSummary(#attributes.shortName#,#attributes.status#,#attributes.batchid#)" returnvariable="itemInfo"/>
		<do action="v.info" contentVariable="pageContent"/>
	</fuseaction>
	
	<fuseaction name="storeinfo">
		<invoke object="application.ediQuery" methodcall="qryStoreSummary(#attributes.shortName#,#attributes.status#,#attributes.batchid#)" returnvariable="storeInfo"/>
		<do action="v.storeinfo" contentVariable="pageContent"/>
	</fuseaction>
	
    <fuseaction name="menu">
		<invoke object="application.ediQuery" methodcall="qryBatch()" returnvariable="batchInfo"/>
		<do action="v.menu"/>
	</fuseaction>
    
     <fuseaction name="autoProcess">
		<invoke object="application.ediQuery" methodcall="autoProcess(#attributes.batchid#)"/>
		<do action="main.menu"/>
	</fuseaction>
	
</circuit>
