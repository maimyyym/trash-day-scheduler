const currentDate = new Date();
const currentYear = currentDate.getFullYear();
const currentMonth = currentDate.getMonth() + 1;

type TrashType = 'unburnable' | 'petBottle';

export const getTrashDay = (trashType: TrashType): Date | undefined => {
    const currentMonthFirstDay: Date = new Date(currentYear,currentMonth - 1, 1);

    // 当月1日の曜日を取得。0: Sunday, 1: Monday, 2: Tuesday, 3: Wednesday, 4: Thursday, 5: Friday, 6: Saturday
    const currentMonthFirstDayOfWeek: number = currentMonthFirstDay.getDay();

    let trashDay: Date;

    let date = currentMonthFirstDay;
    let dayOfWeek = currentMonthFirstDayOfWeek;

    if (trashType === 'unburnable') {
        trashDay = getUnburnableTrashDay(date, dayOfWeek);
        return trashDay;
    }

    if (trashType === 'petBottle') {
        trashDay = getPetBottleTrashDay(date, dayOfWeek);
        return trashDay;
    }
}

const getUnburnableTrashDay = (date: Date, dayOfWeek: number): Date => {
    // 第一火曜日まで進める
    while (dayOfWeek !== 2) {
        date.setDate(date.getDate() + 1);
        dayOfWeek = date.getDay();
    }
    const unBurnableTrashDay = date;
    
    return unBurnableTrashDay;
}

const getPetBottleTrashDay = (date: Date, dayOfWeek: number): Date => {
    // 第三火曜日まで進める
    while (dayOfWeek !== 2) {
        // 第一火曜日まで進める
        date.setDate(date.getDate() + 1);
        dayOfWeek = date.getDay();
    }
    // 14日進めて第三火曜日にする；
    date.setDate(date.getDate() + 14);
    const petBottleTrashDay = date;
    
    return petBottleTrashDay;
}