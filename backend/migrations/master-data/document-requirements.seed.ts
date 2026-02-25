import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Escape a string for safe use in a SQL VALUES clause.
 */
function esc(val: string | null | undefined): string {
    if (val === null || val === undefined) return 'NULL';
    return `'${val.replace(/'/g, "''")}'`;
}

interface DocReqRow {
    businessType: string;
    documentType: string;
    isRequired: boolean;
    description: string;
    displayOrder: number;
}

// All BusinessType enum values
const ALL_BUSINESS_TYPES = [
    'MASSAGE_THERAPY',
    'MASSAGE_REHABILITATION',
    'SPA_BEAUTY',
    'FITNESS',
    'PHARMACY',
    'DENTAL',
    'TRADITIONAL_MEDICINE',
    'PSYCHOLOGY',
    'DERMATOLOGY',
    'NUTRITION',
    'PSYCHIATRY',
];

export class SeedDocumentRequirements1770100000001
    implements MigrationInterface
{
    name = 'SeedDocumentRequirements1770100000001';

    public async up(queryRunner: QueryRunner): Promise<void> {
        console.log('🌱 Seeding document requirements...');

        const requirements: DocReqRow[] = [
            // ========================================
            // I. COMMON DOCUMENTS (All types)
            // ========================================
            ...ALL_BUSINESS_TYPES.map((bt) => ({
                businessType: bt,
                documentType: 'BUSINESS_LICENSE',
                isRequired: true,
                description: 'Giấy ĐKKD (ERC) và Mã số thuế',
                displayOrder: 1,
            })),

            // ========================================
            // II. BUSINESS-SPECIFIC DOCUMENTS
            // ========================================

            // 1. MASSAGE_THERAPY
            {
                businessType: 'MASSAGE_THERAPY',
                documentType: 'ANTT',
                isRequired: true,
                description:
                    'Giấy chứng nhận An ninh trật tự (theo Nghị định 96)',
                displayOrder: 10,
            },

            // 2. MASSAGE_REHABILITATION
            {
                businessType: 'MASSAGE_REHABILITATION',
                documentType: 'KCB_LICENSE',
                isRequired: true,
                description:
                    'Giấy phép hoạt động Khám chữa bệnh (Sở Y tế cấp)',
                displayOrder: 10,
            },

            // 3. SPA_BEAUTY — No special license required

            // 4. FITNESS
            {
                businessType: 'FITNESS',
                documentType: 'GCN_FITNESS',
                isRequired: true,
                description:
                    'GCN đủ điều kiện kinh doanh thể thao (Liên đoàn Thể thao cấp)',
                displayOrder: 10,
            },

            // 5. PHARMACY
            {
                businessType: 'PHARMACY',
                documentType: 'GPP',
                isRequired: true,
                description:
                    'Giấy chứng nhận đủ điều kiện kinh doanh dược (GPP)',
                displayOrder: 10,
            },

            // 6. DENTAL
            {
                businessType: 'DENTAL',
                documentType: 'RHM_LICENSE',
                isRequired: true,
                description:
                    'Giấy phép hoạt động khám bệnh, chữa bệnh (Răng Hàm Mặt)',
                displayOrder: 10,
            },
            {
                businessType: 'DENTAL',
                documentType: 'MEDICAL_WASTE_CONTRACT',
                isRequired: true,
                description: 'Hợp đồng xử lý rác thải y tế',
                displayOrder: 11,
            },

            // 7. TRADITIONAL_MEDICINE
            {
                businessType: 'TRADITIONAL_MEDICINE',
                documentType: 'YHCT_LICENSE',
                isRequired: true,
                description:
                    'Giấy phép hoạt động khám bệnh, chữa bệnh (Y học cổ truyền)',
                displayOrder: 10,
            },

            // 8. PSYCHOLOGY
            {
                businessType: 'PSYCHOLOGY',
                documentType: 'PSYCHOLOGY_LICENSE',
                isRequired: true,
                description:
                    'Giấy phép hoạt động KCB hoặc Giấy phép thành lập trung tâm (Tùy mô hình Y tế/Phi y tế)',
                displayOrder: 10,
            },

            // 9. DERMATOLOGY
            {
                businessType: 'DERMATOLOGY',
                documentType: 'DERMATOLOGY_LICENSE',
                isRequired: true,
                description:
                    'Giấy phép hoạt động KCB (Da liễu/Phẫu thuật thẩm mỹ)',
                displayOrder: 10,
            },
            {
                businessType: 'DERMATOLOGY',
                documentType: 'TECHNICAL_PORTFOLIO',
                isRequired: true,
                description: 'Danh mục kỹ thuật được duyệt',
                displayOrder: 11,
            },

            // 10. NUTRITION
            {
                businessType: 'NUTRITION',
                documentType: 'NUTRITION_LICENSE',
                isRequired: true,
                description:
                    'Giấy phép hoạt động KCB hoặc ĐKKD tư vấn dinh dưỡng',
                displayOrder: 10,
            },

            // 11. PSYCHIATRY
            {
                businessType: 'PSYCHIATRY',
                documentType: 'PSYCHIATRY_LICENSE',
                isRequired: true,
                description:
                    'Giấy phép hoạt động KCB (Tâm thần) - Cơ sở được phép kê đơn thuốc',
                displayOrder: 10,
            },
        ];

        // Build VALUES clause for a single batch INSERT
        const values = requirements
            .map(
                (r) =>
                    `(uuid_generate_v4(), ${esc(r.businessType)}, ${esc(r.documentType)}, ${r.isRequired}, ${esc(r.description)}, ${r.displayOrder})`,
            )
            .join(',\n');

        await queryRunner.query(
            `INSERT INTO "health_partner_document_requirement"
                ("id", "business_type", "document_type", "is_required", "description", "display_order")
             VALUES ${values}`,
        );

        console.log(
            `✅ Seeded ${requirements.length} document requirements`,
        );
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(
            'TRUNCATE TABLE "health_partner_document_requirement" RESTART IDENTITY CASCADE',
        );
        console.log('🗑️ Document requirements data truncated');
    }
}
