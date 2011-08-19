<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fusebox>
<!--
	Example fusebox.xml control file. Shows how to define circuits, classes,
	parameters and global fuseactions.
-->
<fusebox>
	<circuits>
		<circuit alias="v" path="views/" parent="" />
		<circuit alias="main" path="controller/" parent="" />
		<circuit alias="layout" path="layout/" parent="" />
	</circuits>

	<classes>
		<class alias="ediParse" classpath="ediWeb.model.ediParse" type="component" constructor="init"/>
		<class alias="ediImport" classpath="ediWeb.model.ediImport" type="component" constructor="init"/>
		<class alias="ediMap" classpath="ediWeb.model.ediMap" type="component" constructor="init"/>
		<class alias="fileActions" classpath="ediWeb.model.fileActions" type="component" constructor="init"/>
		<class alias="ediQuery" classpath="ediWeb.model.ediQuery" type="component" constructor="init"/>
		<class alias="createCsv" classpath="ediWeb.model.createCsv" type="component" constructor="init"/>
        <class alias="email" classpath="ediWeb.model.email" type="component" constructor="init"/>
	</classes>

	<parameters>
		<parameter name="defaultFuseaction" value="main.home" />
		<parameter name="mode" value="development-full-load" />
		<parameter name="password" value="" />
		<parameter name="fuseactionVariable" value="fuseaction" />
		<parameter name="precedenceFormOrUrl" value="form" />
		<parameter name="scriptFileDelimiter" value="cfm" />
		<parameter name="maskedFileDelimiters" value="htm,cfm,cfml,php,php4,asp,aspx" />
		<parameter name="characterEncoding" value="utf-8" />		
		<paramater name="strictMode" value="false" />
		<parameter name="allowImplicitCircuits" value="false" />
		<parameter name="debug" value="false" />		
	</parameters>

	<globalfuseactions>
		<postprocess>
		<do action="main.menu" />
		<do action="layout.apply" />
		</postprocess>
	</globalfuseactions>

	<plugins>
		<phase name="preProcess">
		</phase>
		<phase name="preFuseaction">
		</phase>
		<phase name="postFuseaction">
		</phase>
		<phase name="fuseactionException">
		</phase>
		<phase name="postProcess">			
		</phase>
		<phase name="processError">
		</phase>
	</plugins>

</fusebox>
