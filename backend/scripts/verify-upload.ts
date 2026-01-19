import axios from 'axios';
import * as fs from 'fs';
import * as path from 'path';

const API_URL = 'http://127.0.0.1:3000';
const TEST_FILE_PATH = path.join(__dirname, 'test-upload.txt');

async function run() {
    try {
        // 1. Create a dummy file
        fs.writeFileSync(TEST_FILE_PATH, 'This is a test document content.');
        console.log('Created test file:', TEST_FILE_PATH);

        // 2. Register a new partner
        const uniqueId = Date.now();
        const registerData = {
            account: {
                email: `partner${uniqueId}@test.com`,
                password: 'Password123!',
                phoneNumber: '0901234567'
            },
            partner: {
                taxCode: `TAX${uniqueId}`,
                legalName: `Test Company ${uniqueId}`,
                brandName: `Test Clinic ${uniqueId}`,
                businessType: 'SPA_BEAUTY',
                provinceId: null,
                districtId: null,
                wardId: null,
                streetAddress: '123 Test St'
            },
            legalRepresentative: {
                fullName: 'Test Rep',
                position: 'Director',
                idType: 'CITIZEN_ID',
                idNumber: `ID${uniqueId}`,
                idIssueDate: '2020-01-01',
                images: {
                    frontImgUrl: 'http://example.com/front.jpg',
                    backImgUrl: 'http://example.com/back.jpg'
                },
                authorization: {
                    isAuthorizedUser: true
                }
            }
        };

        console.log('Registering partner...');
        const regRes = await axios.post(`${API_URL}/auth/partner/register`, registerData);
        const accessToken = regRes.data.access_token;
        console.log('Registration successful. Got token.');

        // 3. Get Upload URL
        console.log('Requesting upload URL...');
        const uploadRes = await axios.post(
            `${API_URL}/partners/me/documents/upload-url`,
            {
                fileName: 'test-upload.txt',
                contentType: 'text/plain'
            },
            {
                headers: { Authorization: `Bearer ${accessToken}` }
            }
        );

        const { uploadUrl, documentKey } = uploadRes.data;
        console.log('Got upload URL:', uploadUrl);
        console.log('Document Key:', documentKey);

        // 4. PUT the file to the URL
        // Note: It is CRITICAL to use the same Content-Type
        console.log('Uploading file to R2 via PUT...');
        const fileContent = fs.readFileSync(TEST_FILE_PATH);

        await axios.put(uploadUrl, fileContent, {
            headers: {
                'Content-Type': 'text/plain'
            }
        });

        console.log('✅ Upload successful! The Presigned URL works correctly with PUT.');

        // 5. Submit the document with the key
        console.log('Submitting document record to API...');
        await axios.post(
            `${API_URL}/partners/me/documents`,
            {
                documentType: 'BUSINESS_LICENSE', // Using a valid type
                documentUrl: uploadUrl, // Legacy/Fallback
                documentKey: documentKey // <--- IMPORTANT: Submitting the key
            },
            {
                headers: { Authorization: `Bearer ${accessToken}` }
            }
        );
        console.log('Document submitted successfully.');

        // 6. Get the View URL (GET)
        console.log('Retrieving View URL...');
        // First get the document ID or list
        const docsRes = await axios.get(`${API_URL}/partners/me/documents`, {
            headers: { Authorization: `Bearer ${accessToken}` }
        });
        // Find our document
        const docStatus = docsRes.data.documents.find((d: any) => d.documentType === 'BUSINESS_LICENSE');

        if (docStatus && docStatus.documentId) {
            // Get signed view URL
            const viewRes = await axios.get(`${API_URL}/partners/me/documents/${docStatus.documentId}/url`, {
                headers: { Authorization: `Bearer ${accessToken}` }
            });
            const viewUrl = viewRes.data.url;
            console.log('Got View URL:', viewUrl);

            // 7. Verify we can GET it
            console.log('Verifying GET access...');
            const downloadRes = await axios.get(viewUrl);
            if (downloadRes.data === 'This is a test document content.') {
                console.log('✅ Cycle Complete: Uploaded (PUT) and Downloaded (GET) successfully!');
            } else {
                console.warn('⚠️ Downloaded content mismatch:', downloadRes.data);
            }
        } else {
            console.warn('Could not find submitted document in status list.');
        }

    } catch (error: any) {
        console.error('❌ Test Failed:', error.message);
        if (error.response) {
            console.error('Response Status:', error.response.status);
            console.error('Response Data:', error.response.data);
        }
    } finally {
        // Cleanup
        if (fs.existsSync(TEST_FILE_PATH)) {
            fs.unlinkSync(TEST_FILE_PATH);
        }
    }
}

run();
