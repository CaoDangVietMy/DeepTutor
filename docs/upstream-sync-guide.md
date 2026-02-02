# DeepTutor - Sync với Upstream Repository

> Hướng dẫn duy trì và cập nhật từ repository gốc HKUDS/DeepTutor

---

## 🎯 Mục tiêu

Giữ fork của bạn luôn cập nhật với upstream (repo gốc) trong khi vẫn bảo toàn các custom configurations cho Cloud Run deployment.

---

## 📋 Setup Ban đầu

### 1. Thêm Upstream Remote

```bash
# Kiểm tra remotes hiện tại
git remote -v

# Thêm upstream (repo gốc)
git remote add upstream https://github.com/HKUDS/DeepTutor.git

# Xác nhận
git remote -v
# origin    https://github.com/caodangvietmy/DeepTutor.git (fetch)
# origin    https://github.com/caodangvietmy/DeepTutor.git (push)  
# upstream  https://github.com/HKUDS/DeepTutor.git (fetch)
# upstream  https://github.com/HKUDS/DeepTutor.git (push)
```

---

## 🔄 Quy trình Sync định kỳ

### Cách 1: Merge (Khuyến nghị cho người mới)

```bash
# 1. Fetch upstream
git fetch upstream

# 2. Checkout branch chính của bạn
git checkout main

# 3. Merge upstream vào local
git merge upstream/main

# 4. Giải quyết conflicts nếu có (xem phần bên dưới)

# 5. Push lên fork của bạn
git push origin main
```

### Cách 2: Rebase (Cho history sạch hơn)

```bash
# 1. Fetch upstream
git fetch upstream

# 2. Checkout branch chính
git checkout main

# 3. Rebase trên upstream
git rebase upstream/main

# 4. Force push (cẩn thận!)
git push origin main --force-with-lease
```

---

## 📁 Các file CẦN BẢO VỆ (Custom của bạn)

Những file này là custom cho deployment của bạn, **KHÔNG nên bị ghi đè** khi sync:

| File | Mô tả |
|------|-------|
| `Dockerfile.cloudrun` | Docker config cho Cloud Run |
| `cloudbuild.yaml` | Cloud Build pipeline |
| `nginx.cloudrun.conf` | Nginx reverse proxy config |
| `scripts/entrypoint.cloudrun.sh` | Container entrypoint |
| `docs/gcp-deployment.md` | Tài liệu deployment |
| `.env` | Environment variables (local) |

### Tạo file .gitattributes để bảo vệ

```bash
# Thêm vào .gitattributes
echo "Dockerfile.cloudrun merge=ours" >> .gitattributes
echo "cloudbuild.yaml merge=ours" >> .gitattributes
echo "nginx.cloudrun.conf merge=ours" >> .gitattributes
echo "scripts/entrypoint.cloudrun.sh merge=ours" >> .gitattributes
```

---

## ⚠️ Xử lý Merge Conflicts

### Conflicts thường gặp

1. **`requirements.txt`** - Upstream thêm dependencies mới
   - ✅ Giữ cả hai: dependencies của upstream + của bạn

2. **`package.json`** - Frontend dependencies  
   - ✅ Giữ cả hai, chạy `npm install` sau merge

3. **`src/api/main.py`** - API changes
   - ✅ Cẩn thận review, giữ logic của upstream
   
4. **Các file deployment** (`Dockerfile.cloudrun`, etc.)
   - ✅ Giữ version của bạn (ours)

### Commands hữu ích

```bash
# Xem files conflict
git status

# Giữ version của bạn cho file cụ thể
git checkout --ours Dockerfile.cloudrun

# Giữ version của upstream cho file cụ thể  
git checkout --theirs requirements.txt

# Đánh dấu conflict đã resolve
git add <file>

# Tiếp tục merge
git merge --continue

# Hủy merge nếu quá phức tạp
git merge --abort
```

---

## 🤖 Tự động hóa với GitHub Actions (Optional)

Tạo file `.github/workflows/sync-upstream.yml`:

```yaml
name: Sync Upstream

on:
  schedule:
    - cron: '0 0 * * 0'  # Chạy mỗi Chủ nhật lúc 00:00 UTC
  workflow_dispatch:      # Cho phép chạy manual

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Sync upstream
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          
          git remote add upstream https://github.com/HKUDS/DeepTutor.git || true
          git fetch upstream
          
          # Tạo branch mới cho sync
          git checkout -b sync-upstream-$(date +%Y%m%d)
          
          # Merge upstream
          git merge upstream/main --no-edit || true
          
          # Push branch
          git push origin sync-upstream-$(date +%Y%m%d)
          
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          title: "🔄 Sync with upstream HKUDS/DeepTutor"
          body: |
            This PR syncs our fork with the upstream repository.
            
            **Review carefully before merging!**
            
            Protected files (keep ours):
            - Dockerfile.cloudrun
            - cloudbuild.yaml
            - nginx.cloudrun.conf
          branch: sync-upstream-${{ github.run_id }}
```

---

## 📅 Lịch Sync đề xuất

| Tần suất | Khi nào | Lý do |
|----------|---------|-------|
| **Hàng tuần** | Chủ nhật | Cập nhật minor fixes, improvements |
| **Khi có release mới** | Ngay lập tức | Major features, security patches |
| **Trước deploy** | Trước mỗi deploy | Đảm bảo có latest changes |

---

## 🚀 Workflow hoàn chỉnh khi Sync và Deploy

```bash
# 1. Sync từ upstream
git fetch upstream
git checkout main
git merge upstream/main

# 2. Resolve conflicts (nếu có)
# ... xử lý conflicts ...
git add .
git commit -m "Merge upstream updates"

# 3. Test local (optional)
docker compose up

# 4. Push to fork
git push origin main

# 5. Deploy to Cloud Run
gcloud builds submit --config cloudbuild.yaml
```

---

## 📝 Changelog Tracking

Ghi lại mỗi lần sync:

| Date | Upstream Commit | Notes |
|------|-----------------|-------|
| 2026-02-02 | Initial fork | Added Cloud Run deployment |
| | | |

---

## 🆘 Troubleshooting

### "Divergent branches" error

```bash
git config pull.rebase false  # Dùng merge strategy
git pull upstream main --allow-unrelated-histories
```

### Muốn reset hoàn toàn theo upstream

```bash
# ⚠️ CẢNH BÁO: Sẽ mất hết custom changes!
git fetch upstream
git checkout main
git reset --hard upstream/main
git push origin main --force
```

### Backup custom files trước khi sync

```bash
# Tạo branch backup
git checkout -b backup-before-sync-$(date +%Y%m%d)
git push origin backup-before-sync-$(date +%Y%m%d)

# Quay lại main để sync
git checkout main
```

---

*Document maintained by DevOps team. Update after each sync operation.*
