import { DataSource } from 'typeorm';
import { DocumentRequirement } from '../entities/document-requirement.entity';
import { BusinessType } from '../enum/business-type.enum';
import { DocumentType } from '../enum/document-type.enum';

/**
 * Seeds document requirements based on business type.
 * 
 * I. Common Documents (All businesses):
 *    - BUSINESS_LICENSE (Giấy ĐKKD + Mã số thuế)
 *    - IDENTITY_FRONT (CCCD mặt trước)
 *    - IDENTITY_BACK (CCCD mặt sau)
 *    - AUTHORIZATION_LETTER (Giấy ủy quyền - optional, only if admin ≠ legal rep)
 * 
 * II. Business-specific Documents (per 11 business types)
 */
export async function seedDocumentRequirements(dataSource: DataSource) {
    const repo = dataSource.getRepository(DocumentRequirement);

    console.log('🌱 Seeding document requirements...');

    // Clear existing to prevent duplicates
    await repo.clear();

    const requirements: Partial<DocumentRequirement>[] = [
        // ========================================
        // I. COMMON DOCUMENTS (All types)
        // ========================================
        ...Object.values(BusinessType).flatMap(businessType => [
            {
                businessType,
                documentType: DocumentType.BUSINESS_LICENSE,
                isRequired: true,
                description: 'Giấy ĐKKD (ERC) và Mã số thuế',
                displayOrder: 1,
            },
        ]),

        // ========================================
        // II. BUSINESS-SPECIFIC DOCUMENTS
        // ========================================

        // === 1. MASSAGE_THERAPY (Massage Thư giãn) ===
        {
            businessType: BusinessType.MASSAGE_THERAPY,
            documentType: DocumentType.ANTT,
            isRequired: true,
            description: 'Giấy chứng nhận An ninh trật tự (theo Nghị định 96)',
            displayOrder: 10,
        },

        // === 2. MASSAGE_REHABILITATION (Massage Trị liệu) ===
        {
            businessType: BusinessType.MASSAGE_REHABILITATION,
            documentType: DocumentType.KCB_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động Khám chữa bệnh (Sở Y tế cấp)',
            displayOrder: 10,
        },

        // === 3. SPA_BEAUTY (Spa & Làm đẹp) ===
        // Note: No special license required - only ERC with noted industries
        // (Chăm sóc da, gội đầu, nail)

        // === 4. FITNESS (Thể hình - Gym/Yoga) ===
        {
            businessType: BusinessType.FITNESS,
            documentType: DocumentType.GCN_FITNESS,
            isRequired: true,
            description: 'GCN đủ điều kiện kinh doanh thể thao (Liên đoàn Thể thao cấp)',
            displayOrder: 10,
        },

        // === 5. PHARMACY (Dược phẩm) ===
        {
            businessType: BusinessType.PHARMACY,
            documentType: DocumentType.GPP,
            isRequired: true,
            description: 'Giấy chứng nhận đủ điều kiện kinh doanh dược (GPP)',
            displayOrder: 10,
        },

        // === 6. DENTAL (Nha khoa) ===
        {
            businessType: BusinessType.DENTAL,
            documentType: DocumentType.RHM_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động khám bệnh, chữa bệnh (Răng Hàm Mặt)',
            displayOrder: 10,
        },
        {
            businessType: BusinessType.DENTAL,
            documentType: DocumentType.MEDICAL_WASTE_CONTRACT,
            isRequired: true,
            description: 'Hợp đồng xử lý rác thải y tế',
            displayOrder: 11,
        },

        // === 7. TRADITIONAL_MEDICINE (Đông y) ===
        {
            businessType: BusinessType.TRADITIONAL_MEDICINE,
            documentType: DocumentType.YHCT_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động khám bệnh, chữa bệnh (Y học cổ truyền)',
            displayOrder: 10,
        },

        // === 8. PSYCHOLOGY (Tâm lý & Trị liệu) ===
        {
            businessType: BusinessType.PSYCHOLOGY,
            documentType: DocumentType.PSYCHOLOGY_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động KCB hoặc Giấy phép thành lập trung tâm (Tùy mô hình Y tế/Phi y tế)',
            displayOrder: 10,
        },

        // === 9. DERMATOLOGY (Da liễu & Thẩm mỹ) ===
        {
            businessType: BusinessType.DERMATOLOGY,
            documentType: DocumentType.DERMATOLOGY_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động KCB (Da liễu/Phẫu thuật thẩm mỹ)',
            displayOrder: 10,
        },
        {
            businessType: BusinessType.DERMATOLOGY,
            documentType: DocumentType.TECHNICAL_PORTFOLIO,
            isRequired: true,
            description: 'Danh mục kỹ thuật được duyệt',
            displayOrder: 11,
        },

        // === 10. NUTRITION (Dinh dưỡng) ===
        {
            businessType: BusinessType.NUTRITION,
            documentType: DocumentType.NUTRITION_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động KCB hoặc ĐKKD tư vấn dinh dưỡng',
            displayOrder: 10,
        },

        // === 11. PSYCHIATRY (Tâm thần học) ===
        {
            businessType: BusinessType.PSYCHIATRY,
            documentType: DocumentType.PSYCHIATRY_LICENSE,
            isRequired: true,
            description: 'Giấy phép hoạt động KCB (Tâm thần) - Cơ sở được phép kê đơn thuốc',
            displayOrder: 10,
        },
    ];

    await repo.save(requirements);
    console.log(`✅ Seeded ${requirements.length} document requirements`);
}
