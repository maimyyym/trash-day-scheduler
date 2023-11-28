export function formatDate(date: Date) {
    let month = date.getMonth() + 1;
    let day = date.getDate();
    const year = date.getFullYear();

    // 月と日が1桁の場合、先頭に0を追加
    month < 10 ? `0${month}` : `${month}`;
    day < 10 ? `0${day}` : `${day}`;

    return `${year}-${month}-${day}`;
}
