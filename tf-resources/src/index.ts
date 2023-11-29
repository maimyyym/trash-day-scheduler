// import { GetParameterCommand, SSMClient } from '@aws-sdk/client-ssm';
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

    const s3Client = new S3Client({region: process.env.AWS_REGION});

    console.log(s3Client);

    const getS3File = async () => {
        const bucketParams = {
            Bucket: `${process.env.S3_BUCKET_NAME}`,
            Key: `${process.env.S3_OBJECT_KEY}`,
        };
    
        try {
            const bucketCommand = new GetObjectCommand(bucketParams);
            const { Body } = await s3Client.send(bucketCommand);
            const responseStr = streamToString(Body);
            return responseStr;
        } catch (err) {
            console.log(err);
        }
    }

    function streamToString(stream) {
        return new Promise((resolve, reject) => {
            const chunks = [];
            stream.on('data', (chunk: never) => chunks.push(chunk));
            stream.on('error', reject);
            stream.on('end', () => resolve(Buffer.concat(chunks).toString('utf8')));
        });
    }

    const unburnableTrashDay = getTrashDay('unburnable');
    const petBottleTrashDay = getTrashDay('petBottle');

    const s3File = await getS3File();

    const createUnburnableTrashDayEvent =  await createEvent(s3File, '燃えないゴミの日', unburnableTrashDay);
    const createPetBottleTrashDayEvent =  await createEvent(s3File, 'ペットボトルゴミの日', petBottleTrashDay);

    return {
        statusCode: 200,
        body: JSON.stringify({  
            message: 'success',
        }),
    }
    }