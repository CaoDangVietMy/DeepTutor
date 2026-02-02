# 💰 Chi Phí Vận Hành DeepTutor trên Google Cloud

> **Document Version:** 1.0  
> **Date:** 2026-01-26  
> **Currency:** USD & VND (tỷ giá ~24,500)

---

## 📊 Tổng Quan Chi Phí Theo Kịch Bản

| Kịch Bản | Users | Requests/tháng | Cloud Run | LLM (GPT-4o) | LLM (GPT-4o-mini) | **TỔNG (GPT-4o)** | **TỔNG (mini)** |
|----------|-------|----------------|-----------|--------------|-------------------|-------------------|-----------------|
| 🏠 **Cá nhân** | 10 | 1,500 | **$0** (free tier) | $105 | $15 | **~$105** | **~$15** |
| 🚀 **Startup** | 100 | 15,000 | $34 | $1,050 | $150 | **~$1,100** | **~$200** |
| 🏢 **Doanh nghiệp nhỏ** | 1,000 | 150,000 | $385 | $10,500 | $1,500 | **~$11,000** | **~$1,900** |
| 🏛️ **Enterprise** | 5,000 | 750,000 | $1,957 | $52,500 | $7,500 | **~$55,000** | **~$9,700** |

> ⚠️ **Phát hiện quan trọng:** LLM API chiếm **90-95%** tổng chi phí! Cloud Run chỉ chiếm 3-5%.

---

## 📈 Chi Tiết Cloud Run (Infrastructure)

### Giá Cơ Bản (asia-southeast1)

| Tài nguyên | Giá | Free Tier/tháng |
|------------|-----|-----------------|
| CPU | $0.000024/vCPU-giây | 180,000 vCPU-giây |
| Memory | $0.0000025/GiB-giây | 360,000 GiB-giây |
| Requests | $0.40/1 triệu | 2 triệu requests |

### Cấu hình DeepTutor

```
CPU:     2 vCPU (tối thiểu cho multi-agent)
Memory:  4 GB (LlamaIndex + RAG)
Thời gian trung bình: 45 giây/request
```

### Tính toán chi tiết - Kịch bản Startup (100 users)

```
📊 500 requests/ngày × 30 ngày = 15,000 requests/tháng

⏱️ Thời gian xử lý:
   • Simple chat: 10 giây
   • Problem solving: 60 giây  
   • Deep research: 180 giây
   • Trung bình: ~45 giây

💻 CPU:
   15,000 × 45s × 2 vCPU = 1,350,000 vCPU-giây
   Trừ free tier: 1,350,000 - 180,000 = 1,170,000
   Chi phí: 1,170,000 × $0.000024 = $28.08

🧠 Memory:
   15,000 × 45s × 4 GiB = 2,700,000 GiB-giây
   Trừ free tier: 2,700,000 - 360,000 = 2,340,000
   Chi phí: 2,340,000 × $0.0000025 = $5.85

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Tổng Cloud Run: ~$34/tháng
```

---

## 🤖 Chi Phí LLM API (Con số thực sự đáng sợ!)

### Giá OpenAI (1/2026)

| Model | Input (1M tokens) | Output (1M tokens) |
|-------|-------------------|-------------------|
| GPT-4o | $2.50 | $10.00 |
| GPT-4o-mini | $0.15 | $0.60 |
| GPT-4-turbo | $10.00 | $30.00 |

### Token Usage per Request (DeepTutor)

```
Multi-agent workflow (trung bình 4 agent calls):
┌─────────────────────────────────────────────┐
│ Request 1: InvestigateAgent                 │
│   Input:  3,000 tokens (context + RAG)      │
│   Output: 1,000 tokens                      │
├─────────────────────────────────────────────┤
│ Request 2: PlanAgent                        │
│   Input:  4,000 tokens                      │
│   Output: 1,000 tokens                      │
├─────────────────────────────────────────────┤
│ Request 3: SolveAgent                       │
│   Input:  4,000 tokens                      │
│   Output: 1,500 tokens                      │
├─────────────────────────────────────────────┤
│ Request 4: CheckAgent                       │
│   Input:  3,000 tokens                      │
│   Output: 500 tokens                        │
├─────────────────────────────────────────────┤
│ TOTAL per user request:                     │
│   Input:  14,000 tokens                     │
│   Output: 4,000 tokens                      │
│                                             │
│   GPT-4o:      $0.035 + $0.040 = $0.075    │
│   GPT-4o-mini: $0.002 + $0.002 = $0.004    │
└─────────────────────────────────────────────┘
```

### So sánh chi phí LLM theo kịch bản

| Kịch bản | Requests | GPT-4o | GPT-4o-mini | Tiết kiệm |
|----------|----------|--------|-------------|-----------|
| Cá nhân | 1,500 | $113 | $6 | **95%** |
| Startup | 15,000 | $1,125 | $60 | **95%** |
| DN nhỏ | 150,000 | $11,250 | $600 | **95%** |
| Enterprise | 750,000 | $56,250 | $3,000 | **95%** |

---

## 🔧 Chi Phí Phụ Trợ

### Google Cloud

| Service | Giá | Ước tính/tháng |
|---------|-----|----------------|
| Container Registry | $0.026/GB | $1-5 |
| Egress (ra internet) | $0.12/GB | $5-20 |
| Cloud Logging | $0.50/GB (50GB free) | $0-10 |

### Firebase (Optional)

| Service | Giá | Ước tính/tháng |
|---------|-----|----------------|
| Firestore writes | $0.18/100K | $5-50 |
| Firestore reads | $0.06/100K | $3-30 |
| Storage | $0.026/GB | $1-10 |
| Auth | Free (50K users) | $0 |

---

## 💡 Chiến Lược Tối Ưu Chi Phí

### 1. Smart Model Routing (Tiết kiệm 80-90%)

```
┌─────────────────────────────────────────────┐
│           User Request                       │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
         ┌───────────────┐
         │ Complexity    │
         │ Classifier    │
         └───────┬───────┘
                 │
     ┌───────────┼───────────┐
     │           │           │
     ▼           ▼           ▼
 ┌───────┐  ┌───────┐  ┌───────┐
 │ Simple│  │Medium │  │Complex│
 │ Chat  │  │ Query │  │ Solve │
 └───┬───┘  └───┬───┘  └───┬───┘
     │          │          │
     ▼          ▼          ▼
 GPT-4o-mini  GPT-4o-mini  GPT-4o
 ($0.004)     ($0.02)      ($0.08)
```

### 2. Caching Layer (Tiết kiệm 30-50%)

- Cache RAG results (2-4 hours TTL)
- Cache similar query responses
- Pre-compute common knowledge

### 3. Minimum Instances = 0 (Quan trọng!)

```bash
gcloud run deploy deeptutor \
  --min-instances 0 \    # Scale to zero khi không dùng
  --max-instances 10 \   # Limit max scale
  --concurrency 80       # Handle nhiều requests/instance
```

### 4. Local LLM cho Development

- Ollama + Llama 3.1 8B: **$0/tháng**
- Chỉ dùng paid API cho production

---

## 📋 Tổng Kết - Chi Phí Tháng Đầu Tiên

### Kịch bản đề xuất: Startup (100 users)

| Hạng mục | GPT-4o | GPT-4o-mini + GPT-4o hybrid |
|----------|--------|------------------------------|
| Cloud Run | $34 | $34 |
| LLM API | $1,125 | $200-400 (smart routing) |
| Firebase | $15 | $15 |
| Egress/Logging | $10 | $10 |
| **TỔNG** | **~$1,184** | **~$260-460** |

### 💵 Quy đổi VND (tỷ giá ~24,500)

| Kịch bản | GPT-4o | Hybrid (tiết kiệm) |
|----------|--------|-------------------|
| 🏠 Cá nhân | 2.5 triệu đ | 400K đ |
| 🚀 Startup | 29 triệu đ | 6-11 triệu đ |
| 🏢 DN nhỏ | 270 triệu đ | 47 triệu đ |
| 🏛️ Enterprise | 1.35 tỷ đ | 240 triệu đ |

---

## ✅ Khuyến Nghị

1. **Bắt đầu với GPT-4o-mini** - Đủ tốt cho 80% use cases
2. **Smart routing**: Dùng GPT-4o chỉ cho complex tasks
3. **Scale từ 0**: Không tốn tiền khi không có traffic
4. **Monitor token usage**: Set alerts khi vượt ngưỡng
5. **Consider self-hosted LLM** cho enterprise (vLLM + A100 GPU)

---

## Appendix: Công Thức Tính

### Cloud Run Cost

```
CPU_cost = (requests × duration × vCPU - FREE_CPU) × $0.000024
Memory_cost = (requests × duration × GiB - FREE_MEM) × $0.0000025
Total = CPU_cost + Memory_cost + Request_cost
```

### LLM Cost

```
Input_cost = total_input_tokens × (price_per_1M / 1,000,000)
Output_cost = total_output_tokens × (price_per_1M / 1,000,000)
Total = Input_cost + Output_cost
```
