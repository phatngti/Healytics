import { DataSource } from 'typeorm';
import { DocumentRequirement } from '../entities/document-requirement.entity';
import { BusinessType } from '../enum/business-type.enum';
import { DocumentType } from '../enum/document-type.enum';

/**
 * Seeds document requirements based on business type.
 * Maps each business category to its required legal documents.
 */
export async function seedDocumentRequirements(dataSource: DataSource) {
    const repo = dataSource.getRepository(DocumentRequirement);

    console.log('🌱 Seeding document requirements...');

    // Clear existing to prevent duplicates
    await repo.clear();

    const requirements: Partial<DocumentRequirement>[] = [
        // === COMMON (All types) ===
        ...Object.values(BusinessType).flatMap(businessType => [
            {
                businessType,
                documentType: DocumentType.TAX_CODE,
                isRequired: true,
                description: 'Mã số thuế (Đã cung cấp khi đăng ký)',
                displayOrder: 1,
            },
            {
                businessType,
                documentType: DocumentType.BUSINESS_LICENSE,
                isRequired: true,
                description: 'Giấy ĐKKD (ERC) / Giấy chứng nhận hộ kinh doanh',
                displayOrder: 2,
            },
            {
                businessType,
                documentType: DocumentType.IDENTITY_FRONT,
                isRequired: true,
                description: 'CCCD/Hộ chiếu (Mặt trước) - Đã cung cấp khi đăng ký',
                displayOrder: 3,
            },
            {
                businessType,
                documentType: DocumentType.IDENTITY_BACK,
                isRequired: true,
                description: 'CCCD/Hộ chiếu (Mặt sau) - Đã cung cấp khi đăng ký',
                displayOrder: 4,
            },
            {
                businessType,
                documentType: DocumentType.AUTHORIZATION_LETTER,
                isRequired: false,
                description: 'Giấy ủy quyền (Nếu có)',
                displayOrder: 100,
            },
        ]),

        // === 1. MASSAGE THERAPY ===
        {
            businessType: BusinessType.MASSAGE_THERAPY,
            documentType: DocumentType.ANTT,
            isRequired: true,
            description: 'Giấy ANTT (Nghị định 96)',
            displayOrder: 3,
        },
        // {
        //     businessType: BusinessType.MASSAGE_THERAPY,
        //     documentType: DocumentType.CCHN_MASSAGE,
        //     isRequired: true,
        //     description: 'Chứng chỉ nghề ký thuật viên (Sơ cấp/Trung cấp)',
        //     displayOrder: 4,
        // },

        // === 2. MASSAGE REHABILITATION ===
        {
            businessType: BusinessType.MASSAGE_REHABILITATION,
            documentType: DocumentType.CCHN,
            isRequired: true,
            description: 'Chứng chỉ hành nghề (CCHN)',
            displayOrder: 3,
        },

        // === 3. SPA & BEAUTY ===
        {
            businessType: BusinessType.SPA_BEAUTY,
            documentType: DocumentType.BUSINESS_LICENSE,
            isRequired: true,
            description: 'ĐKKD (Chăm sóc da, gội đầu, nail)',
            displayOrder: 3,
        },
        {
            businessType: BusinessType.SPA_BEAUTY,
            documentType: DocumentType.CCHN,
            isRequired: false,
            description: 'Chứng chỉ đào tạo nghề (nếu có)',
            displayOrder: 4,
        },

        // === 4. FITNESS ===
        {
            businessType: BusinessType.FITNESS,
            documentType: DocumentType.GCN_FITNESS,
            isRequired: true,
            description: 'GCN đủ điều kiện kinh doanh thể thao',
            displayOrder: 3,
        },
        // {
        //     businessType: BusinessType.FITNESS,
        //     documentType: DocumentType.CCHN,
        //     isRequired: false,
        //     description: 'Bằng/Chứng chỉ HLV chuyên nghiệp (Liên đoàn Thể thao cấp)',
        //     displayOrder: 4,
        // },

        // === 5. PHARMACY ===
        {
            businessType: BusinessType.PHARMACY,
            documentType: DocumentType.GPP,
            isRequired: true,
            description: 'GCN đủ điều kiện kinh doanh dược (GPP)',
            displayOrder: 3,
        },
        {
            businessType: BusinessType.PHARMACY,
            documentType: DocumentType.CCHN_PHARMACY,
            isRequired: true,
            description: 'CCHN Dược sĩ (của Dược sĩ phụ trách)',
            displayOrder: 4,
        },

        // === 6. DENTAL ===
        {
            businessType: BusinessType.DENTAL,
            documentType: DocumentType.RHM_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động khám bệnh, chữa bệnh (RHM)',
            displayOrder: 3,
        },
        // {
        //     businessType: BusinessType.DENTAL,
        //     documentType: DocumentType.CCHN_DENTAL,
        //     isRequired: true,
        //     description: 'CCHN Bác sĩ Răng Hàm Mặt',
        //     displayOrder: 4,
        // },

        // === 7. TRADITIONAL MEDICINE ===
        {
            businessType: BusinessType.TRADITIONAL_MEDICINE,
            documentType: DocumentType.YHCT_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động khám bệnh, chữa bệnh (YHCT)',
            displayOrder: 3,
        },
        // {
        //     businessType: BusinessType.TRADITIONAL_MEDICINE,
        //     documentType: DocumentType.CCHN,
        //     isRequired: true,
        //     description: 'CCHN Lương y hoặc Bác sĩ YHCT',
        //     displayOrder: 4,
        // },

        // === 8. PSYCHOLOGY ===
        {
            businessType: BusinessType.PSYCHOLOGY,
            documentType: DocumentType.CCHN_PSYCHOLOGY,
            isRequired: true,
            description: 'Bằng Cử nhân/Thạc sĩ/Tiến sĩ Tâm lý hoặc CCHN Tâm lý lâm sàng',
            displayOrder: 3,
        },

        // === 9. DERMATOLOGY ===
        {
            businessType: BusinessType.DERMATOLOGY,
            documentType: DocumentType.DERMATOLOGY_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động KCB (Da liễu/PTTM)',
            displayOrder: 3,
        },
        // {
        //     businessType: BusinessType.DERMATOLOGY,
        //     documentType: DocumentType.CCHN,
        //     isRequired: true,
        //     description: 'CCHN Bác sĩ + Chứng chỉ thú thuật (CME) (nếu có)',
        //     displayOrder: 4,
        // },
        {
            businessType: BusinessType.DERMATOLOGY,
            documentType: DocumentType.PORTFOLIO,
            isRequired: false,
            description: 'Danh mục kỹ thuật được duyệt',
            displayOrder: 5,
        },

        // === 10. NUTRITION ===
        {
            businessType: BusinessType.NUTRITION,
            documentType: DocumentType.CCHN_NUTRITION,
            isRequired: true,
            description: 'CCHN Bác sĩ chuyên khoa Dinh dưỡng',
            displayOrder: 3,
        },

        // === 11. PSYCHIATRY ===
        {
            businessType: BusinessType.PSYCHIATRY,
            documentType: DocumentType.PSYCHIATRY_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động KCB Tâm thần học',
            displayOrder: 3,
        },
        // {
        //     businessType: BusinessType.PSYCHIATRY,
        //     documentType: DocumentType.CCHN,
        //     isRequired: true,
        //     description: 'CCHN Bác sĩ chuyên khoa Tâm thần',
        //     displayOrder: 4,
        // },
    ];

    await repo.save(requirements);
    console.log(`✅ Seeded ${requirements.length} document requirements`);
}
