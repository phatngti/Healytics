/**
 * Document types for partner verification.
 * 
 * Categories:
 * I. Common Documents (All businesses)
 * II. Business-specific Documents (Per industry)
 */
export enum DocumentType {
    // ========================================
    // I. COMMON DOCUMENTS (All businesses)
    // ========================================

    /** Giấy ĐKKD (ERC) / Mã số thuế - Business Registration & Tax Code */
    BUSINESS_LICENSE = 'BUSINESS_LICENSE',

    /** CCCD/Hộ chiếu (Mặt trước) - Legal Representative ID Front */
    IDENTITY_FRONT = 'IDENTITY_FRONT',

    /** CCCD/Hộ chiếu (Mặt sau) - Legal Representative ID Back */
    IDENTITY_BACK = 'IDENTITY_BACK',

    /** Giấy ủy quyền - Authorization Letter (if admin is not legal rep) */
    AUTHORIZATION_LETTER = 'AUTHORIZATION_LETTER',

    // ========================================
    // II. BUSINESS-SPECIFIC DOCUMENTS
    // ========================================

    // 1. Massage Thư giãn
    /** Giấy chứng nhận An ninh trật tự (Nghị định 96) */
    ANTT = 'ANTT',

    // 2. Massage Trị liệu
    /** Giấy phép hoạt động Khám chữa bệnh (Sở Y tế cấp) */
    KCB_LICENSE = 'KCB_LICENSE',

    // 3. Spa & Làm đẹp
    // Note: No special license required, only ERC with noted industries

    // 4. Thể hình (Gym/Yoga)
    /** GCN đủ điều kiện kinh doanh thể thao (Liên đoàn Thể thao cấp) */
    GCN_FITNESS = 'GCN_FITNESS',

    // 5. Dược phẩm
    /** Giấy chứng nhận đủ điều kiện kinh doanh dược (GPP) */
    GPP = 'GPP',

    // 6. Nha khoa
    /** Giấy phép hoạt động KCB Răng Hàm Mặt */
    RHM_LICENSE = 'RHM_LICENSE',

    /** Hợp đồng xử lý rác thải y tế */
    MEDICAL_WASTE_CONTRACT = 'MEDICAL_WASTE_CONTRACT',

    // 7. Đông y
    /** Giấy phép hoạt động KCB Y học cổ truyền */
    YHCT_LICENSE = 'YHCT_LICENSE',

    // 8. Tâm lý & Trị liệu
    /** Giấy phép hoạt động KCB hoặc Giấy phép thành lập trung tâm */
    PSYCHOLOGY_LICENSE = 'PSYCHOLOGY_LICENSE',

    // 9. Da liễu & Thẩm mỹ
    /** Giấy phép hoạt động KCB (Da liễu/Phẫu thuật thẩm mỹ) */
    DERMATOLOGY_LICENSE = 'DERMATOLOGY_LICENSE',

    /** Danh mục kỹ thuật được duyệt */
    TECHNICAL_PORTFOLIO = 'TECHNICAL_PORTFOLIO',

    // 10. Dinh dưỡng
    /** Giấy phép hoạt động KCB hoặc ĐKKD tư vấn */
    NUTRITION_LICENSE = 'NUTRITION_LICENSE',

    // 11. Tâm thần học
    /** Giấy phép hoạt động KCB (Tâm thần) */
    PSYCHIATRY_LICENSE = 'PSYCHIATRY_LICENSE',
}
