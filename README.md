# TrashDayScheduler
## What is this?
On the first of each month, a Lambda will be triggered to register the garbage disposal date in Google Calendar.
### Default Settings
- First Tuesday of the month: Non-burnable Garbage Day
- Third Tuesday of the month: PET Bottle Garbage Day

## Usage
### make directory "creds"
Get your google  calendar API credentials JSON, put it in "creds/"

### make file "ts-resources/terraform.tfvars"
```
$ cd ts-resources/
$ cp terraform.tfvars.example terraform.tfvars
```
Write your variables!

### Run your terraform command!
Fight🙇🏻‍♀️✊🏻

## Change settings
Please read src/getTrashDay.ts🫣