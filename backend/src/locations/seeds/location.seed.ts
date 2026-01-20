import { DataSource } from 'typeorm';
import axios from 'axios';
import { Location } from '../entities/location.entity';
import { LocationLevel } from '../entities/location-level.enum';

interface ProvinceData {
    Id: string;
    Name: string;
    Districts: DistrictData[];
}

interface DistrictData {
    Id: string;
    Name: string;
    Wards: WardData[];
}

interface WardData {
    Id: string;
    Name: string;
    Level: string;
}

const DATA_SOURCE_URL =
    'https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json';


function slugify(str: string): string {
    if (!str) return '';
    return str
        .toLowerCase()
        .normalize('NFD') // Tách dấu ra khỏi ký tự
        .replace(/[\u0300-\u036f]/g, '') // Xóa các ký tự dấu
        .replace(/[đĐ]/g, 'd') // Xử lý chữ đ
        .replace(/\s+/g, '_') // Thay khoảng trắng bằng _
        .replace(/[^a-z0-9_]/g, ''); // Xóa các ký tự đặc biệt còn lại
}

function formatFullName(name: string, level: string): string {
    if (!name) return '';
    const nameLower = name.toLowerCase();
    const levelLower = (level || '').toLowerCase();

    if (nameLower.startsWith(levelLower)) {
        return name;
    }
    return `${level} ${name}`;
}

export async function seedLocations(dataSource: DataSource) {
    const locationRepo = dataSource.getTreeRepository(Location);

    console.log('🌱 Seeding Vietnam locations (Tree structure) with UPSERT...');
    const startTime = Date.now();

    try {

        console.log('Cleaning old data (TRUNCATE CASCADE)...');
        try {
            await locationRepo.query('TRUNCATE TABLE "location" RESTART IDENTITY CASCADE');
            console.log('Old data cleaned successfully');
        } catch (e) {
            // Fallback nếu database không hỗ trợ TRUNCATE CASCADE
            console.warn('TRUNCATE failed, using DELETE fallback...');
            await locationRepo.delete({});
        }

        console.log(`📡 Fetching data from API...`);
        const { data } = await axios.get<ProvinceData[]>(DATA_SOURCE_URL);
        console.log(`✅ Fetched ${data.length} provinces from API`);

        // Vì đã xóa sạch bảng, existingMap sẽ rỗng, mọi entity đều là INSERT mới
        console.log('🔄 Starting fresh seed (no existing data to check)...');
        const existingMap = new Map<string, string>(); // Empty map - all inserts

        let provinceCount = 0;
        let districtCount = 0;
        let wardCount = 0;

        for (const p of data) {
            if (!p.Id || !p.Name) continue;

            const provinceCode = String(p.Id).padStart(2, '0');
            const provinceName = p.Name;

            // ✨ Dùng hàm slugify mới
            const cleanCodeName = slugify(provinceName);

            const province = locationRepo.create({
                code: provinceCode,
                name: provinceName,
                nameEn: null,
                fullName: provinceName,
                fullNameEn: null,
                codeName: cleanCodeName,
                level: LocationLevel.PROVINCE,
                parent: null,
            } as any) as unknown as Location;

            const savedProvince = await locationRepo.save(province);
            existingMap.set(savedProvince.code, savedProvince.id);
            provinceCount++;

            if (!p.Districts) continue;

            const districtEntities: Location[] = [];

            for (const d of p.Districts) {
                if (!d.Id || !d.Name) continue;

                const districtCode = String(d.Id).padStart(3, '0');
                const districtName = d.Name;
                const cleanDistrictCodeName = slugify(districtName);

                const district = locationRepo.create({
                    code: districtCode,
                    name: districtName,
                    nameEn: null,
                    fullName: districtName,
                    fullNameEn: null,
                    codeName: cleanDistrictCodeName,
                    level: LocationLevel.DISTRICT,
                    parent: savedProvince,
                } as any) as unknown as Location;

                districtEntities.push(district);
            }

            let savedDistricts: Location[] = [];
            if (districtEntities.length > 0) {
                savedDistricts = await locationRepo.save(districtEntities);
                savedDistricts.forEach((d) => existingMap.set(d.code, d.id));
                districtCount += savedDistricts.length;
            }

            const districtMapByCode = new Map(savedDistricts.map((d) => [d.code, d]));
            const wardEntities: Location[] = [];

            for (const dData of p.Districts) {
                const districtCode = String(dData.Id).padStart(3, '0');
                const parentDistrict = districtMapByCode.get(districtCode);

                if (!parentDistrict || !dData.Wards) continue;

                for (const w of dData.Wards) {
                    if (!w || !w.Id || !w.Name) continue;

                    const wardCode = String(w.Id).padStart(5, '0');
                    const wardName = w.Name;
                    const wLevel = w.Level || 'Xã';
                    const fullWardName = formatFullName(wardName, wLevel);
                    const cleanWardCodeName = slugify(wardName);

                    const ward = locationRepo.create({
                        code: wardCode,
                        name: wardName,
                        nameEn: null,
                        fullName: fullWardName,
                        fullNameEn: null,
                        codeName: cleanWardCodeName, // ✅ phuong_ben_nghe
                        level: LocationLevel.WARD,
                        parent: parentDistrict,
                    } as any) as unknown as Location;

                    wardEntities.push(ward);
                }
            }

            if (wardEntities.length > 0) {
                await locationRepo.save(wardEntities, { chunk: 500 });
                wardCount += wardEntities.length;
            }

            console.log(
                `   ✅ Processed ${provinceName}: ${savedDistricts.length} districts, ${wardEntities.length} wards.`,
            );
        }

        const duration = ((Date.now() - startTime) / 1000).toFixed(2);
        console.log(`\n🎉 DONE! Seeded successfully in ${duration}s`);
        console.log(`   - Provinces: ${provinceCount}`);
        console.log(`   - Districts: ${districtCount}`);
        console.log(`   - Wards: ${wardCount}`);
    } catch (error) {
        console.error('❌ Error during seeding:', error);
        if (error.detail) console.error('DB Detail:', error.detail);
    }
}