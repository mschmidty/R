# How to Load an Access Database into R using the backage RODBC

## Things to know about the DB

* ** Important!!!!!! ** The database cannot be stored in the same file as the .r file it has to be stored in a separate folder. 

* The RODBC package can only be used with 32 bit version - In Sublime REPL this need to be changed in the preferences>browse packages and then sublimeREPL>config>R>Main and change the source of the Rterm.exe to  - C:/Users/mschmidt/R/R-3.2.0/bin/i386/Rterm.exe

## Attribute Key
* ReqKey - Represents a line

## Tables and Query Key 
* **qryBLMLPISpecies** - Has each line 

## Process for getting the right AIM data
### Get Tables and Queries out of DIMA

DIMA has tables turned off by default. To turn them on and start working with the data, go to: File>Options>Current Database>Display Navigation Pane

You will be able to see the Access Object Pain on the left hand side of the screen. 

### For LPI Coverages by Species
In the All Access Objects pane scroll down to the Queries section.  Find the **qryBLMLPISpeciesSum**.  Open the Quarry, and go to Design View. In design right click the top section and select "Show Table".  A new table will come up and add "tblSites".  Once tblSites is open drag **SiteID** into the quarry. Hit save. This will allow you to querry out the sites that you want in R.