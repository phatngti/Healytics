import { MigrationInterface, QueryRunner } from 'typeorm';
import axios from 'axios';

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
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/[đĐ]/g, 'd')
        .replace(/\s+/g, '_')
        .replace(/[^a-z0-9_]/g, '');
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

/**
 * Escape a string for safe use in a SQL VALUES clause.
 * Replaces single quotes with two single quotes (standard SQL escaping).
 */
function esc(val: string | null | undefined): string {
    if (val === null || val === undefined) return 'NULL';
    return `'${val.replace(/'/g, "''")}'`;
}

export class SeedLocations1770100000000 implements MigrationInterface {
    name = 'SeedLocations1770100000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        console.log('🌱 Seeding Vietnam locations (raw SQL batch)...');
        const startTime = Date.now();

        console.log('📡 Fetching data from API...');
        const { data } = await axios.get<ProvinceData[]>(DATA_SOURCE_URL);
        console.log(`✅ Fetched ${data.length} provinces from API`);

        let provinceCount = 0;
        let districtCount = 0;
        let wardCount = 0;

        for (const p of data) {
            if (!p.Id || !p.Name) continue;

            const provinceCode = String(p.Id).padStart(2, '0');
            const provinceName = p.Name;
            const cleanCodeName = slugify(provinceName);

            // Insert province and get its UUID
            const [{ id: provinceId }] = await queryRunner.query(
                `INSERT INTO "location" ("id", "code", "name", "name_en", "full_name", "full_name_en", "code_name", "level", "parent_id", "mpath")
                 VALUES (uuid_generate_v4(), $1, $2, NULL, $3, NULL, $4, 'PROVINCE', NULL, '')
                 RETURNING "id"`,
                [provinceCode, provinceName, provinceName, cleanCodeName],
            );

            // Set mpath for province (materialized-path = "<id>.")
            const provinceMpath = `${provinceId}.`;
            await queryRunner.query(
                `UPDATE "location" SET "mpath" = $1 WHERE "id" = $2`,
                [provinceMpath, provinceId],
            );
            provinceCount++;

            if (!p.Districts || p.Districts.length === 0) {
                console.log(`   ✅ Processed ${provinceName}: 0 districts, 0 wards.`);
                continue;
            }

            // --- Batch insert districts ---
            const districtValues: string[] = [];
            const districtCodeToIndex = new Map<string, number>();

            for (const d of p.Districts) {
                if (!d.Id || !d.Name) continue;
                const districtCode = String(d.Id).padStart(3, '0');
                const districtName = d.Name;
                const cleanDistrictCodeName = slugify(districtName);

                districtCodeToIndex.set(districtCode, districtValues.length);
                districtValues.push(
                    `(uuid_generate_v4(), ${esc(districtCode)}, ${esc(districtName)}, NULL, ${esc(districtName)}, NULL, ${esc(cleanDistrictCodeName)}, 'DISTRICT', '${provinceId}', '')`,
                );
            }

            const districtRows: { id: string; code: string }[] = [];
            if (districtValues.length > 0) {
                // Insert in batches of 500 to stay within query limits
                const BATCH = 500;
                for (let i = 0; i < districtValues.length; i += BATCH) {
                    const batch = districtValues.slice(i, i + BATCH);
                    const rows = await queryRunner.query(
                        `INSERT INTO "location" ("id", "code", "name", "name_en", "full_name", "full_name_en", "code_name", "level", "parent_id", "mpath")
                         VALUES ${batch.join(',\n')}
                         RETURNING "id", "code"`,
                    );
                    districtRows.push(...rows);
                }

                // Batch update mpath for all districts
                const mpathCases = districtRows
                    .map((d) => `WHEN '${d.id}' THEN '${provinceMpath}${d.id}.'`)
                    .join(' ');
                const districtIds = districtRows.map((d) => `'${d.id}'`).join(',');
                await queryRunner.query(
                    `UPDATE "location" SET "mpath" = CASE "id" ${mpathCases} END WHERE "id" IN (${districtIds})`,
                );

                districtCount += districtRows.length;
            }

            // Build code -> {id, mpath} map for districts
            const districtMap = new Map<string, { id: string; mpath: string }>();
            for (const row of districtRows) {
                const mpath = `${provinceMpath}${row.id}.`;
                districtMap.set(row.code, { id: row.id, mpath });
            }

            // --- Batch insert wards ---
            const wardValues: string[] = [];
            const wardParentMpaths: string[] = []; // parallel array to track parent mpath per ward

            for (const dData of p.Districts) {
                const districtCode = String(dData.Id).padStart(3, '0');
                const parentDistrict = districtMap.get(districtCode);
                if (!parentDistrict || !dData.Wards) continue;

                for (const w of dData.Wards) {
                    if (!w || !w.Id || !w.Name) continue;
                    const wardCode = String(w.Id).padStart(5, '0');
                    const wardName = w.Name;
                    const wLevel = w.Level || 'Xã';
                    const fullWardName = formatFullName(wardName, wLevel);
                    const cleanWardCodeName = slugify(wardName);

                    wardValues.push(
                        `(uuid_generate_v4(), ${esc(wardCode)}, ${esc(wardName)}, NULL, ${esc(fullWardName)}, NULL, ${esc(cleanWardCodeName)}, 'WARD', '${parentDistrict.id}', '')`,
                    );
                    wardParentMpaths.push(parentDistrict.mpath);
                }
            }

            if (wardValues.length > 0) {
                const BATCH = 500;
                const allWardRows: { id: string }[] = [];

                for (let i = 0; i < wardValues.length; i += BATCH) {
                    const batch = wardValues.slice(i, i + BATCH);
                    const rows = await queryRunner.query(
                        `INSERT INTO "location" ("id", "code", "name", "name_en", "full_name", "full_name_en", "code_name", "level", "parent_id", "mpath")
                         VALUES ${batch.join(',\n')}
                         RETURNING "id"`,
                    );
                    allWardRows.push(...rows);
                }

                // Batch update mpath for all wards
                const mpathCases = allWardRows
                    .map((w, idx) => `WHEN '${w.id}' THEN '${wardParentMpaths[idx]}${w.id}.'`)
                    .join(' ');
                const wardIds = allWardRows.map((w) => `'${w.id}'`).join(',');

                // Update in batches to avoid query size limits
                const UPDATE_BATCH = 1000;
                for (let i = 0; i < allWardRows.length; i += UPDATE_BATCH) {
                    const batchRows = allWardRows.slice(i, i + UPDATE_BATCH);
                    const batchParents = wardParentMpaths.slice(i, i + UPDATE_BATCH);
                    const cases = batchRows
                        .map((w, idx) => `WHEN '${w.id}' THEN '${batchParents[idx]}${w.id}.'`)
                        .join(' ');
                    const ids = batchRows.map((w) => `'${w.id}'`).join(',');
                    await queryRunner.query(
                        `UPDATE "location" SET "mpath" = CASE "id" ${cases} END WHERE "id" IN (${ids})`,
                    );
                }

                wardCount += allWardRows.length;
            }

            console.log(
                `   ✅ Processed ${provinceName}: ${districtRows.length} districts, ${wardValues.length} wards.`,
            );
        }

        const duration = ((Date.now() - startTime) / 1000).toFixed(2);
        console.log(`\n🎉 DONE! Seeded locations in ${duration}s`);
        console.log(`   - Provinces: ${provinceCount}`);
        console.log(`   - Districts: ${districtCount}`);
        console.log(`   - Wards: ${wardCount}`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(
            'TRUNCATE TABLE "location" RESTART IDENTITY CASCADE',
        );
        console.log('🗑️ Location data truncated');
    }
}