import axios from 'axios';

// Default port to 8080 based on main.ts
const PORT = process.env.PORT || 8080;
const API_URL = `http://127.0.0.1:${PORT}`;

async function run() {
    try {
        console.log(`Connecting to API at: ${API_URL}`);

        // 1. Login as Admin
        console.log('Logging in as Admin...');
        // Using default credentials from AuthService or commonly seeded ones
        const adminEmail = 'admin@healytics.com';
        const adminPassword = 'admin@123';

        try {
            const loginRes = await axios.post(`${API_URL}/auth/admin/login`, {
                email: adminEmail,
                password: adminPassword
            });

            const accessToken = loginRes.data.access_token;
            console.log('✅ Admin login successful');

            // 2. Get Partners List
            console.log('Fetching Partners List...');
            const partnersRes = await axios.get(`${API_URL}/partners`, {
                params: { page: 1, limit: 10 },
                headers: { Authorization: `Bearer ${accessToken}` }
            });

            console.log('✅ Get Partners Response Status:', partnersRes.status);
            console.log('Total Partners:', partnersRes.data.total);
            console.log('Data returned:', partnersRes.data.data.length, 'records');

            if (partnersRes.data.data.length > 0) {
                console.log('First Partner Sample:', JSON.stringify(partnersRes.data.data[0], null, 2));
            } else {
                console.log('No partners found in the list.');
            }

        } catch (loginError: any) {
            if (loginError.code === 'ECONNREFUSED') {
                console.error(`❌ Connection Refused at ${API_URL}. Is the server running?`);
                // Helper logic: Maybe it's on 3000?
                if (PORT === 8080) {
                    console.log('Tip: Try checking if PORT 3000 is used instead.');
                }
            } else {
                console.error('❌ Login Failed:', loginError.response?.data || loginError.message);
            }
        }

    } catch (error: any) {
        console.error('❌ Test Failed:', error.message);
    }
}

run();
