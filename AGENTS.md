# Bootstrap 本地化使用規格

## 目的

將 `index.html` 的 Bootstrap 資源改為本地引用，避免依賴 CDN，並為後續維護提供清晰檔案結構與說明。

## 目前配置

### HTML 檔案
- `index.html`
  - 引用本地 Bootstrap CSS：`css/bootstrap.min.css`
  - 引用本地 Bootstrap Icons 包裝 CSS：`css/bootstrap-icons.css`
  - 引用本地 Bootstrap JS：`js/bootstrap.bundle.min.js`

### CSS 檔案
- `css/bootstrap.min.css`
  - Bootstrap 主樣式檔案，從官方下載後放入本地 `css` 資料夾。
- `css/bootstrap-icons.css`
  - Bootstrap Icons 的本地包裝檔，透過 `@import` 引用同資料夾中的 `bootstrap-icons.min.css`。
  - 目的是讓後續其他頁面只需要引用這個統一入口 CSS 檔。
- `css/bootstrap-icons.min.css`
  - Bootstrap Icons 的實際 CSS 檔案，需與 `bootstrap-icons.css` 同放在 `css` 資料夾。
  - 若尚未放入，需補上此檔案。
- Icons 字體檔案
  - 若 `bootstrap-icons.min.css` 依賴字體檔，請將字體檔放置於 `css/fonts/` 或 `css/` 內，並確認 CSS 中 `font-face` 路徑正確。

### JS 檔案
- `js/bootstrap.bundle.min.js`
  - Bootstrap JavaScript 套件，包含 Popper 與 Bootstrap JS。
  - 確保此檔與 `index.html` 的 `<script>` 引用路徑一致。

## 維護說明

1. 若要新增頁面引用 Bootstrap：
   - 在頁面 `<head>` 加上
     ```html
     <link href="css/bootstrap.min.css" rel="stylesheet">
     <link href="css/bootstrap-icons.css" rel="stylesheet">
     ```
   - 在頁面底部加上
     ```html
     <script src="js/bootstrap.bundle.min.js"></script>
     ```

2. 若要更新 Bootstrap 版本：
   - 重新下載官方 Bootstrap 壓縮檔
   - 替換 `css/bootstrap.min.css` 與 `js/bootstrap.bundle.min.js`
   - 確認 `index.html` 與其他頁面引用的本地路徑不變。

3. 若要更新 Bootstrap Icons：
   - 下載最新版 `bootstrap-icons.min.css` 及其字體檔
   - 放入 `css/`（或 `css/fonts/`）
   - 確認 `css/bootstrap-icons.css` 中的 `@import url("./bootstrap-icons.min.css");` 不需修改。

4. 圖標字體路徑檢查
   - 若 Bootstrap Icons 內部使用相對路徑載入字體，請檢查 `bootstrap-icons.min.css` 中的 `url(...)` 是否正確指向本地字體檔。

## 注意事項

- 若有未來頁面使用 SVG 或第三方圖示，請確認符號名稱是否與 Bootstrap Icons 衝突。
- 若希望統一管理更多第三方 CSS，可考慮新增 `css/vendor.css` 作為外部套件匯入入口。
