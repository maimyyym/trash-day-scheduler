import { google } from 'googleapis';

export const createEvent = async (credsFile): Promise<void> => {
    const creds = JSON.parse(credsFile);
    const auth = new google.auth.GoogleAuth({
        credentials: creds,
        scopes: ['https://www.googleapis.com/auth/calendar'],
    });
    const calendar = google.calendar({ version: 'v3', auth });

    const event = {
        summary: 'test',
        start: {
            dateTime: '2023-10-28T09:00:00-07:00',
            timeZone: 'Asia/Tokyo',
        },
        end: {
            dateTime: '2023-10-29T17:00:00-07:00',
            timeZone: 'Asia/Tokyo',
        },
    };

    calendar.events.insert({
        calendarId: `${process.env.CALENDAR_ID}`,
        requestBody: event,
    }, (err, res) => {
        if (err) {
            return console.log('The API returned an error: ' + err);
        }
        return res.data;
    });
}