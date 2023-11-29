import { google } from 'googleapis';
import { formatDate } from './formatDate';

export const createEvent = async (credsFile, eventTitle, datetime): Promise<void> => {
    const creds = JSON.parse(credsFile);
    const auth = new google.auth.GoogleAuth({
        credentials: creds,
        scopes: ['https://www.googleapis.com/auth/calendar'],
    });
    const calendar = google.calendar({ version: 'v3', auth });

    const date = formatDate(datetime);

    const event = {
        summary: eventTitle,
        start: {
            date: date,
            timeZone: 'Asia/Tokyo',
        },
        end: {
            date: date,
            timeZone: 'Asia/Tokyo',
        },
    };

    try {
        const response = await calendar.events.insert({
            calendarId: `${process.env.CALENDAR_ID}`,
            requestBody: event,
        });
    } catch (err) {
            return console.log('The API returned an error: ' + err);
        }
}