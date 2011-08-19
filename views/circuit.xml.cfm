<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE circuit>

<circuit access="internal">

	<fuseaction name="dump">
		<include template="dsp_dump"/>
	</fuseaction>
	
	<fuseaction name="info">		
		<xfa name="autoProcess" value="main.autoProcess"/>
		<xfa name="viewStoreInfo" value="main.storeinfo"/>		
		<include template="dsp_info"/>
	</fuseaction>
	
	<fuseaction name="storeInfo">		
		<xfa name="viewOrders" value="main.info"/>	
		<include template="dsp_storeinfo"/>
	</fuseaction>
	
	<fuseaction name="menu">
		<xfa name="createCSVFile" value="main.createCSVFile"/>
		<xfa name="viewOrders" value="main.info"/>		
		<xfa name="viewComplete" value="main.complete"/>
		<xfa name="export" value="main.export"/>
        <xfa name="email" value="main.email"/>
		<include template="dsp_menu" contentVariable="pageMenu" />
	</fuseaction>
    
    <fuseaction name="test">		
		<include template="dsp_test" contentVariable="pageContent"/>
	</fuseaction>
	
</circuit>
