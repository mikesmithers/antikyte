# Installing a Custom Tab in SQLDeveloper Classic

In SQLDeveloper select the **Tools** Menu then **Preferences**.

Search for User Defined Extensions

![User Defined Extensions](sqld_prefs_user_defined_extensions.png)

Click the **Add Row** button then click in the **Type** field and select *Editor* from the drop-down list

![Choose Extension Type](add_editor_extension1.png)

In the **Location** field, enter the full path to the xml file containing the extension you want to add

![Extension file path](add_editor_extension2.png)

Hit **OK**

Restart SQLDeveloper. 
When you select an object of the type for which this extension is defined ( Tables in this example), you will see the new tab has been added

![Partition Keys Tab](new_tab.png)

The new tab will work like any other :

![Partition Key Tab details](partition_keys_tab.png)
