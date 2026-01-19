export enum DocumentType {
    // General (Required for all businesses)
    TAX_CODE = 'TAX_CODE',                    // Mã số thuế - Personal or Business
    BUSINESS_LICENSE = 'BUSINESS_LICENSE',    // Giấy phép kinh doanh / Giấy ĐKKD (ERC)
    IDENTITY_FRONT = 'IDENTITY_FRONT',        // CCCD/Hộ chiếu (Mặt trước)
    IDENTITY_BACK = 'IDENTITY_BACK',          // CCCD/Hộ chiếu (Mặt sau)
    AUTHORIZATION_LETTER = 'AUTHORIZATION_LETTER', // Giấy ủy quyền (nếu có)
    ANTT = 'ANTT',                            // Giấy ANTT (Nghị định 96) - Massage Therapy
    CCHN = 'CCHN',                            // Chứng chỉ hành nghề - Multiple types
    GPP = 'GPP',                              // Giấy phép Dược (Good Pharmacy Practice)
    GCN_FITNESS = 'GCN_FITNESS',              // GCN điều kiện KD thể thao
    RHM_LICENSE = 'RHM_LICENSE',              // Giấy phép hoạt động khám bệnh Răng Hàm Mặt
    YHCT_LICENSE = 'YHCT_LICENSE',            // Giấy phép Y học cổ truyền (Đông y)
    PSYCHIATRY_LICENSE = 'PSYCHIATRY_LICENSE', // Giấy phép Tâm thần học
    DERMATOLOGY_LICENSE = 'DERMATOLOGY_LICENSE', // Giấy phép Da liễu/Thẩm mỹ

    // Professional Certificates
    CCHN_MASSAGE = 'CCHN_MASSAGE',            // CCHN Massage/Trị liệu
    CCHN_PHARMACY = 'CCHN_PHARMACY',          // CCHN Dược sĩ/Bác sĩ
    CCHN_DENTAL = 'CCHN_DENTAL',              // CCHN Bác sĩ Răng Hàm Mặt
    CCHN_NUTRITION = 'CCHN_NUTRITION',        // CCHN Bác sĩ dinh dưỡng
    CCHN_PSYCHOLOGY = 'CCHN_PSYCHOLOGY',      // Bằng/Chứng chỉ Tâm lý

    // Additional Documents
    PORTFOLIO = 'PORTFOLIO',                  // Danh mục kỹ thuật được duyệt
}
