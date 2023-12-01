# TrashDayScheduler
## What is this?
On the first of each month, a Lambda will be triggered to register the garbage disposal date in Google Calendar.
### Default Settings
- First Tuesday of the month: Non-burnable Garbage Day
- Third Tuesday of the month: PET Bottle Garbage Day

## Usage
### Make directory "creds"
Get your google  calendar API credentials JSON, put it in "creds/"

### Make file "tf-resources/terraform.tfvars"
```
$ cd tf-resources/
$ cp terraform.tfvars.example terraform.tfvars
```
Write your variables!

### Run your terraform command!
Fight🙇🏻‍♀️✊🏻

## Change settings
Please read src/getTrashDay.ts🫣
