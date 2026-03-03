import type { ConversationListItemDto } from '@/chatbot/dto/conversation-list.dto';

// ═══════════════════════════════════════════════════════════════════════════════
// Types
// ═══════════════════════════════════════════════════════════════════════════════

export interface MockNerEntity {
  type: string;
  value: string;
  confidence: number;
}

export interface MockServiceRecommendation {
  service_id: string;
  name: string;
  image_url: string;
  badge: string;
  booked_count: number;
  price: { amount: number; currency: string };
  staff_name: string;
  rating: { average: number; total_reviews: number };
  location: { address: string; district: string; city: string };
  slots: string[];
}

/**
 * A single mock script that bundles a coherent response, NER entities,
 * and service recommendations in the same context.
 */
export interface MockScript {
  /** The full-text AI replies (each element becomes a separate streamed message) */
  response: string[];
  /** NER entities extracted from the response */
  entities: MockNerEntity[];
  /** Services recommended based on the response context */
  recommendations: MockServiceRecommendation[];
}

/**
 * A multi-turn conversation script that groups semantically related
 * {@link MockScript} turns under one conversation context.
 *
 * When the user sends multiple messages within the same conversation,
 * the service iterates through the `turns` array in order, providing
 * contextually evolving responses.
 */
export interface MockConversationScript {
  /** Conversation-level title */
  title: string;
  /** Ordered list of AI responses in this conversation */
  turns: MockScript[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Mock Conversation Scripts (multi-turn)
// ═══════════════════════════════════════════════════════════════════════════════

export const MOCK_CONVERSATION_SCRIPTS: MockConversationScript[] = [
  // ── Conversation 1: Đau lưng & cột sống ───────────────────────────────────
  {
    title: 'Đau lưng & phục hồi cột sống',
    turns: [
      // Turn 1: Spine recovery — Quận 1
      {
        response: [
          'Chào bạn! Tôi đã phân tích triệu chứng đau lưng mà bạn mô tả.',
          'Dựa trên thông tin bạn cung cấp, nguyên nhân có thể liên quan đến thoái hóa đĩa đệm hoặc sai tư thế kéo dài.',
          'Tôi đề xuất dịch vụ phục hồi cột sống chuyên sâu tại Quận 1, Hồ Chí Minh — đây là cơ sở được đánh giá rất cao.',
          'Bạn nên đặt lịch sớm để được bác sĩ chuyên khoa thăm khám trực tiếp nhé!',
        ],
        entities: [{ type: 'LOCATION', value: 'Quận 1', confidence: 0.93 }],
        recommendations: [
          {
            service_id: 'SV002',
            name: 'Phục hồi cột sống chuyên sâu',
            image_url: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop',
            badge: 'Premium',
            booked_count: 1200,
            price: { amount: 800000, currency: 'VND' },
            staff_name: 'BS Nguyễn Văn A',
            rating: { average: 4.8, total_reviews: 124 },
            location: { address: '123 Nguyễn Huệ', district: 'Quận 1', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T09:00:00', '2026-03-03T14:00:00'],
          },
          {
            service_id: 'SV009',
            name: 'Gói trị liệu đau lưng mãn tính',
            image_url: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400&h=300&fit=crop',
            badge: 'Phổ biến',
            booked_count: 850,
            price: { amount: 650000, currency: 'VND' },
            staff_name: 'ThS Trần Minh B',
            rating: { average: 4.6, total_reviews: 98 },
            location: { address: '45 Lê Lợi', district: 'Quận 1', city: 'Hồ Chí Minh' },
            slots: ['2026-03-04T10:00:00', '2026-03-04T15:30:00'],
          },
        ],
      },
      // Turn 2: Chronic back pain — Quận 3
      {
        response: [
          'Cảm ơn bạn đã chia sẻ thêm chi tiết về tình trạng đau lưng.',
          'Triệu chứng đau kéo dài hơn 3 tháng cho thấy đây có thể là đau lưng mãn tính, cần được điều trị chuyên sâu.',
          'Tôi đề xuất Gói trị liệu đau lưng mãn tính tại Quận 3 — bác sĩ ở đây có kinh nghiệm xử lý các ca tương tự.',
          'Ngoài ra, bạn có thể kết hợp với sóng xung kích để đạt hiệu quả tốt hơn.',
        ],
        entities: [
          { type: 'LOCATION', value: 'Quận 3', confidence: 0.89 },
          { type: 'SYMPTOM', value: 'đau lưng', confidence: 0.88 },
        ],
        recommendations: [
          {
            service_id: 'SV009',
            name: 'Gói trị liệu đau lưng mãn tính',
            image_url: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400&h=300&fit=crop',
            badge: 'Phổ biến',
            booked_count: 850,
            price: { amount: 650000, currency: 'VND' },
            staff_name: 'ThS Trần Minh B',
            rating: { average: 4.6, total_reviews: 98 },
            location: { address: '200 Nguyễn Thị Minh Khai', district: 'Quận 3', city: 'Hồ Chí Minh' },
            slots: ['2026-03-04T10:00:00', '2026-03-04T15:30:00'],
          },
          {
            service_id: 'SV033',
            name: 'Sóng xung kích điều trị viêm khớp',
            image_url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&h=300&fit=crop',
            badge: 'Chuyên sâu',
            booked_count: 620,
            price: { amount: 900000, currency: 'VND' },
            staff_name: 'PGS.TS Hoàng Minh E',
            rating: { average: 4.7, total_reviews: 156 },
            location: { address: '15 Võ Văn Tần', district: 'Quận 3', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T10:00:00', '2026-03-06T10:00:00'],
          },
        ],
      },
    ],
  },

  // ── Conversation 2: Vai gáy & massage ─────────────────────────────────────
  {
    title: 'Đau vai gáy & massage trị liệu',
    turns: [
      // Turn 1: Acupuncture + cupping — Phú Nhuận
      {
        response: [
          'Tôi nhận thấy bạn đang gặp vấn đề về vai gáy — đây là triệu chứng rất phổ biến ở dân văn phòng.',
          'Nguyên nhân thường do ngồi sai tư thế, sử dụng máy tính kéo dài hoặc căng thẳng tích tụ ở vùng cổ vai.',
          'Phương pháp châm cứu kết hợp giác hơi tại Quận Phú Nhuận đã giúp nhiều bệnh nhân cải thiện rõ rệt.',
          'BS Lê Thị C tại đây có hơn 10 năm kinh nghiệm trong lĩnh vực y học cổ truyền, bạn có thể yên tâm!',
        ],
        entities: [
          { type: 'LOCATION', value: 'Phú Nhuận', confidence: 0.90 },
          { type: 'SYMPTOM', value: 'đau vai gáy', confidence: 0.85 },
        ],
        recommendations: [
          {
            service_id: 'SV015',
            name: 'Châm cứu kết hợp giác hơi',
            image_url: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=400&h=300&fit=crop',
            badge: 'Đánh giá cao',
            booked_count: 1580,
            price: { amount: 450000, currency: 'VND' },
            staff_name: 'BS Lê Thị C',
            rating: { average: 4.9, total_reviews: 203 },
            location: { address: '78 Phan Xích Long', district: 'Phú Nhuận', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T08:00:00', '2026-03-03T16:00:00'],
          },
        ],
      },
      // Turn 2: Full-body massage — Quận 5
      {
        response: [
          'Ngoài vấn đề vai gáy, tôi thấy bạn cũng đề cập đến tình trạng mệt mỏi toàn thân.',
          'Massage trị liệu toàn thân là phương pháp hiệu quả giúp giải phóng căng cơ và cải thiện tuần hoàn máu.',
          'Hiện có chương trình ưu đãi tại Quận 5 mà bạn nên tham khảo, giá rất hợp lý.',
          'Bên cạnh đó, Yoga trị liệu kết hợp thiền định cũng là lựa chọn tuyệt vời để duy trì sức khỏe lâu dài.',
        ],
        entities: [{ type: 'LOCATION', value: 'Quận 5', confidence: 0.87 }],
        recommendations: [
          {
            service_id: 'SV021',
            name: 'Massage trị liệu toàn thân',
            image_url: 'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=400&h=300&fit=crop',
            badge: 'Ưu đãi',
            booked_count: 430,
            price: { amount: 550000, currency: 'VND' },
            staff_name: 'KTV Phạm Văn D',
            rating: { average: 4.5, total_reviews: 67 },
            location: { address: '200 Nguyễn Thị Minh Khai', district: 'Quận 3', city: 'Hồ Chí Minh' },
            slots: ['2026-03-05T09:30:00', '2026-03-05T13:00:00'],
          },
          {
            service_id: 'SV040',
            name: 'Yoga trị liệu & thiền định',
            image_url: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=300&fit=crop',
            badge: 'Mới',
            booked_count: 310,
            price: { amount: 350000, currency: 'VND' },
            staff_name: 'HLV Nguyễn Thanh F',
            rating: { average: 4.4, total_reviews: 89 },
            location: { address: '99 Nguyễn Hữu Cảnh', district: 'Bình Thạnh', city: 'Hồ Chí Minh' },
            slots: ['2026-03-04T07:00:00', '2026-03-04T17:00:00'],
          },
        ],
      },
    ],
  },

  // ── Conversation 3: Đau đầu & thiền ───────────────────────────────────────
  {
    title: 'Đau đầu & quản lý căng thẳng',
    turns: [
      // Turn 1: Chronic headache — Quận 10
      {
        response: [
          'Chào bạn, đau đầu mãn tính là vấn đề cần được quan tâm nghiêm túc.',
          'Triệu chứng này có thể liên quan đến tư thế ngồi sai, thiếu ngủ, hoặc căng thẳng kéo dài.',
          'Tôi khuyên bạn nên đặt lịch khám chuyên khoa thần kinh tại Quận 10 để được chẩn đoán chính xác.',
        ],
        entities: [
          { type: 'LOCATION', value: 'Quận 10', confidence: 0.86 },
          { type: 'SYMPTOM', value: 'đau đầu', confidence: 0.92 },
        ],
        recommendations: [
          {
            service_id: 'SV002',
            name: 'Phục hồi cột sống chuyên sâu',
            image_url: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop',
            badge: 'Premium',
            booked_count: 1200,
            price: { amount: 800000, currency: 'VND' },
            staff_name: 'BS Nguyễn Văn A',
            rating: { average: 4.8, total_reviews: 124 },
            location: { address: '123 Nguyễn Huệ', district: 'Quận 1', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T09:00:00', '2026-03-03T14:00:00'],
          },
          {
            service_id: 'SV015',
            name: 'Châm cứu kết hợp giác hơi',
            image_url: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=400&h=300&fit=crop',
            badge: 'Đánh giá cao',
            booked_count: 1580,
            price: { amount: 450000, currency: 'VND' },
            staff_name: 'BS Lê Thị C',
            rating: { average: 4.9, total_reviews: 203 },
            location: { address: '78 Phan Xích Long', district: 'Phú Nhuận', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T08:00:00', '2026-03-03T16:00:00'],
          },
        ],
      },
      // Turn 2: Yoga + meditation — Bình Thạnh
      {
        response: [
          'Dựa trên cuộc trò chuyện của chúng ta, tôi nhận thấy căng thẳng là yếu tố chính gây ra đau đầu của bạn.',
          'Quản lý căng thẳng đóng vai trò then chốt trong việc cải thiện sức khỏe tổng thể và giảm tần suất đau đầu.',
          'Thiền và yoga trị liệu tại trung tâm Bình Thạnh là giải pháp tự nhiên, không dùng thuốc mà rất hiệu quả.',
          'Nhiều bệnh nhân đã giảm đáng kể triệu chứng sau 2-3 tuần tập luyện đều đặn.',
        ],
        entities: [{ type: 'LOCATION', value: 'Bình Thạnh', confidence: 0.87 }],
        recommendations: [
          {
            service_id: 'SV040',
            name: 'Yoga trị liệu & thiền định',
            image_url: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=300&fit=crop',
            badge: 'Mới',
            booked_count: 310,
            price: { amount: 350000, currency: 'VND' },
            staff_name: 'HLV Nguyễn Thanh F',
            rating: { average: 4.4, total_reviews: 89 },
            location: { address: '99 Nguyễn Hữu Cảnh', district: 'Bình Thạnh', city: 'Hồ Chí Minh' },
            slots: ['2026-03-04T07:00:00', '2026-03-04T17:00:00'],
          },
        ],
      },
    ],
  },

  // ── Conversation 4: Tê bì & viêm khớp ────────────────────────────────────
  {
    title: 'Tê bì chân tay & viêm khớp',
    turns: [
      // Turn 1: Numbness — Thủ Đức
      {
        response: [
          'Triệu chứng tê bì chân tay mà bạn mô tả cần được kiểm tra sớm để loại trừ các nguyên nhân nghiêm trọng.',
          'Tê bì có thể do chèn ép dây thần kinh, thiếu vitamin B12, hoặc vấn đề về tuần hoàn máu.',
          'Tôi gợi ý phòng khám vật lý trị liệu ở Thủ Đức — nơi đây có trang thiết bị hiện đại để chẩn đoán chính xác.',
          'Trong thời gian chờ đợi, bạn nên tránh ngồi xổm và hạn chế mang vác nặng nhé!',
        ],
        entities: [
          { type: 'LOCATION', value: 'Thủ Đức', confidence: 0.85 },
          { type: 'SYMPTOM', value: 'tê bì chân tay', confidence: 0.90 },
        ],
        recommendations: [
          {
            service_id: 'SV002',
            name: 'Phục hồi cột sống chuyên sâu',
            image_url: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop',
            badge: 'Premium',
            booked_count: 1200,
            price: { amount: 800000, currency: 'VND' },
            staff_name: 'BS Nguyễn Văn A',
            rating: { average: 4.8, total_reviews: 124 },
            location: { address: '123 Nguyễn Huệ', district: 'Quận 1', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T09:00:00', '2026-03-03T14:00:00'],
          },
          {
            service_id: 'SV033',
            name: 'Sóng xung kích điều trị viêm khớp',
            image_url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&h=300&fit=crop',
            badge: 'Chuyên sâu',
            booked_count: 620,
            price: { amount: 900000, currency: 'VND' },
            staff_name: 'PGS.TS Hoàng Minh E',
            rating: { average: 4.7, total_reviews: 156 },
            location: { address: '15 Võ Văn Tần', district: 'Quận 3', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T10:00:00', '2026-03-06T10:00:00'],
          },
          {
            service_id: 'SV021',
            name: 'Massage trị liệu toàn thân',
            image_url: 'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=400&h=300&fit=crop',
            badge: 'Ưu đãi',
            booked_count: 430,
            price: { amount: 550000, currency: 'VND' },
            staff_name: 'KTV Phạm Văn D',
            rating: { average: 4.5, total_reviews: 67 },
            location: { address: '200 Nguyễn Thị Minh Khai', district: 'Quận 3', city: 'Hồ Chí Minh' },
            slots: ['2026-03-05T09:30:00', '2026-03-05T13:00:00'],
          },
        ],
      },
      // Turn 2: Knee arthritis — Quận 1
      {
        response: [
          'Về triệu chứng viêm khớp gối bạn vừa đề cập, đây là tình trạng khá phổ biến và hoàn toàn có thể điều trị được.',
          'Phương pháp sóng xung kích (Shockwave Therapy) đang là xu hướng điều trị viêm khớp hiệu quả nhất hiện nay.',
          'Dịch vụ này được đánh giá rất cao tại Quận 1, do PGS.TS Hoàng Minh E trực tiếp thực hiện.',
          'Liệu trình thường kéo dài 4-6 buổi, mỗi buổi cách nhau 1 tuần để đạt kết quả tối ưu.',
        ],
        entities: [
          { type: 'LOCATION', value: 'Quận 1', confidence: 0.93 },
          { type: 'SYMPTOM', value: 'viêm khớp gối', confidence: 0.91 },
        ],
        recommendations: [
          {
            service_id: 'SV033',
            name: 'Sóng xung kích điều trị viêm khớp',
            image_url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&h=300&fit=crop',
            badge: 'Chuyên sâu',
            booked_count: 620,
            price: { amount: 900000, currency: 'VND' },
            staff_name: 'PGS.TS Hoàng Minh E',
            rating: { average: 4.7, total_reviews: 156 },
            location: { address: '15 Võ Văn Tần', district: 'Quận 3', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T10:00:00', '2026-03-06T10:00:00'],
          },
          {
            service_id: 'SV002',
            name: 'Phục hồi cột sống chuyên sâu',
            image_url: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop',
            badge: 'Premium',
            booked_count: 1200,
            price: { amount: 800000, currency: 'VND' },
            staff_name: 'BS Nguyễn Văn A',
            rating: { average: 4.8, total_reviews: 124 },
            location: { address: '123 Nguyễn Huệ', district: 'Quận 1', city: 'Hồ Chí Minh' },
            slots: ['2026-03-03T09:00:00', '2026-03-03T14:00:00'],
          },
        ],
      },
    ],
  },

  // ── Conversation 5: Large-text stress test ──────────────────────────────
  {
    title: 'Tư vấn tổng quát sức khỏe toàn diện',
    turns: [
      {
        response: [
          'Chào bạn! Sau khi xem xét kỹ lưỡng các thông tin sức khỏe mà bạn đã cung cấp, tôi muốn chia sẻ một số nhận định quan trọng. Trước hết, chỉ số BMI của bạn cho thấy bạn đang ở ngưỡng thừa cân nhẹ, điều này có thể ảnh hưởng đến sức khỏe tim mạch và hệ cơ xương khớp trong dài hạn. Huyết áp của bạn ở mức 130/85 mmHg — đây là mức tiền tăng huyết áp cần được theo dõi thường xuyên. Về mặt dinh dưỡng, tôi nhận thấy chế độ ăn hiện tại của bạn thiếu hụt vitamin D và omega-3, hai dưỡng chất quan trọng cho sức khỏe xương và não bộ. Bên cạnh đó, mức cholesterol LDL hơi cao có thể liên quan đến thói quen ăn uống nhiều chất béo bão hòa. Tôi khuyên bạn nên bắt đầu một chương trình tập luyện nhẹ nhàng, kết hợp đi bộ nhanh 30 phút mỗi ngày với các bài tập stretching cơ bản. Đồng thời, hãy bổ sung thêm rau xanh, cá hồi, và các loại hạt vào bữa ăn hàng ngày. Việc giảm muối và đường cũng là điều cần thiết để kiểm soát huyết áp và cân nặng hiệu quả hơn.',
          'Ngoài ra, tôi cũng muốn đề cập đến vấn đề giấc ngủ mà bạn đã chia sẻ. Chất lượng giấc ngủ kém không chỉ ảnh hưởng đến năng suất làm việc mà còn tác động trực tiếp đến hệ miễn dịch và quá trình phục hồi cơ thể. Theo nghiên cứu mới nhất, người trưởng thành cần từ 7-9 tiếng ngủ mỗi đêm, và quan trọng hơn cả là duy trì thời gian đi ngủ và thức dậy đều đặn. Tôi gợi ý bạn nên thiết lập một routine trước khi ngủ: tắt các thiết bị điện tử ít nhất 1 tiếng trước giờ ngủ, uống trà hoa cúc hoặc thực hiện các bài tập thở sâu để giúp cơ thể thư giãn. Nếu tình trạng mất ngủ kéo dài hơn 2 tuần, bạn nên đặt lịch khám chuyên khoa giấc ngủ để được tư vấn và điều trị chuyên sâu. Trung tâm y tế tại Quận 7 có phòng khám rối loạn giấc ngủ được trang bị máy đo đa ký giấc ngủ hiện đại, giúp chẩn đoán chính xác nguyên nhân và đưa ra phác đồ điều trị phù hợp nhất cho từng cá nhân.',
        ],
        entities: [
          { type: 'LOCATION', value: 'Quận 7', confidence: 0.88 },
          { type: 'SYMPTOM', value: 'mất ngủ', confidence: 0.91 },
          { type: 'SYMPTOM', value: 'thừa cân', confidence: 0.84 },
        ],
        recommendations: [
          {
            service_id: 'SV050',
            name: 'Khám sức khỏe tổng quát Premium',
            image_url: 'https://images.unsplash.com/photo-1551190822-a9333d879b1f?w=400&h=300&fit=crop',
            badge: 'Premium',
            booked_count: 2100,
            price: { amount: 2500000, currency: 'VND' },
            staff_name: 'BS.CKI Trần Thị G',
            rating: { average: 4.9, total_reviews: 312 },
            location: { address: '500 Nguyễn Hữu Thọ', district: 'Quận 7', city: 'Hồ Chí Minh' },
            slots: ['2026-03-05T08:00:00', '2026-03-05T13:30:00'],
          },
          {
            service_id: 'SV051',
            name: 'Chẩn đoán rối loạn giấc ngủ',
            image_url: 'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400&h=300&fit=crop',
            badge: 'Chuyên sâu',
            booked_count: 540,
            price: { amount: 1800000, currency: 'VND' },
            staff_name: 'ThS.BS Lê Hoàng H',
            rating: { average: 4.7, total_reviews: 87 },
            location: { address: '88 Phú Thuận', district: 'Quận 7', city: 'Hồ Chí Minh' },
            slots: ['2026-03-06T20:00:00', '2026-03-07T20:00:00'],
          },
        ],
      },
    ],
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// Mock Conversation History
// ═══════════════════════════════════════════════════════════════════════════════

export const MOCK_CONVERSATIONS: ConversationListItemDto[] = [
  {
    id: 'conv_001',
    title: 'Headache treatment options',
    lastMessage: 'Try resting and staying hydrated.',
    timestamp: '2026-03-01T14:30:00.000Z',
  },
  {
    id: 'conv_002',
    title: 'Skin care recommendation',
    lastMessage: "I'd suggest a hydrating serum.",
    timestamp: '2026-02-28T09:15:00.000Z',
  },
  {
    id: 'conv_003',
    title: 'Back pain relief exercises',
    lastMessage: 'Try these stretches daily for 2 weeks.',
    timestamp: '2026-02-27T16:45:00.000Z',
  },
  {
    id: 'conv_004',
    title: 'Vitamin D deficiency',
    lastMessage: 'Consider sunlight exposure and supplements.',
    timestamp: '2026-02-26T11:00:00.000Z',
  },
  {
    id: 'conv_005',
    title: 'Sleep improvement tips',
    lastMessage: 'Maintain a consistent sleep schedule.',
    timestamp: '2026-02-25T22:30:00.000Z',
  },
];
