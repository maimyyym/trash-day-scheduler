import { GetParameterCommand, SSMClient } from '@aws-sdk/client-ssm';
import { GetObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getTrashDay } from './getTrashDay';
import { createEvent } from './createEvent';

export const handler = async (event: any) => {

    /* -----<ここから> ssm動作確認済み
    // const ssmClient = new SSMClient({ region: process.env.AWS_REGION });

    // const params = {
    //     Name: process.env.SSM_PARAMETER_NAME,
    //     WithDecryption: true,
    // };
    // const command = new GetParameterCommand(params);
    // const response = await ssmClient.send(command);
    <ここまで>-----*/

    const s3Client = new S3Client({});

    console.log(s3Client);

    const bucketParams = {
        Bucket: `${process.env.S3_BUCKET_NAME}`,
        Key: `${process.env.S3_OBJECT_KEY}`,
    };

    console.log(bucketParams);

    const getS3File = async (bucketParams) => {
        try {
            const bucketCommand = new GetObjectCommand(bucketParams);
            console.log(bucketCommand);
            const bucketResponse = await s3Client.send(bucketCommand);
            console.log(bucketResponse);
            const responseStr = bucketResponse.Body?.transformToString;
            return responseStr;
        } catch (err) {
            console.log(err);
        }
    }

    const unburnableTrashDay = getTrashDay('unburnable');
    const petBottleTrashDay = getTrashDay('petBottle');

    console.log(unburnableTrashDay);
    console.log(petBottleTrashDay);

    const s3File = await getS3File(bucketParams);

    const createEventResponse =  await createEvent(s3File);

    console.log(createEventResponse);

    return {
        statusCode: 200,
        body: JSON.stringify({  
            message: 'Hello World!',
        }),
    }
    }