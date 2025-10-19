# CRUD Table Template

完整的 CRUD 列表頁面範本，使用 `common-table` component。

## 功能

- ✅ Material Table with sorting & pagination
- ✅ Row selection (checkbox)
- ✅ Edit button per row
- ✅ Add / Delete / Refresh toolbar buttons
- ✅ Loading state
- ✅ API integration (create/read/update/delete)
- ✅ Confirmation dialog for delete
- ✅ Signal-based state management
- ✅ OnPush change detection

## 使用方式

### 方法 1: 使用 Slash Command (推薦)

```bash
/new-crud firmware
```

### 方法 2: 手動複製並替換

1. 複製 `component.ts.template` 和 `component.html.template`
2. 重命名為你的 entity name
3. 替換所有變數：

**變數對照表**:

| 變數 | 說明 | 範例 |
|------|------|------|
| `{{EntityName}}` | Pascal Case | `Firmware` |
| `{{entity-name}}` | kebab-case | `firmware` |
| `{{domain-name}}` | 模組名稱 | `system`, `device-deployment` |

**全域替換範例** (VSCode):

```
{{EntityName}}  → Firmware
{{entity-name}} → firmware
{{domain-name}} → management
```

## 需要準備的檔案

使用此範本前，確保以下檔案存在：

### 1. Domain Layer

**{{entity-name}}.model.ts**
```typescript
export interface {{EntityName}} {
  id: string;
  name: string;
  status: string;
  createdAt: string;
  // ... other properties
}
```

**{{entity-name}}-api.service.ts**
```typescript
@Injectable({ providedIn: 'root' })
export class {{EntityName}}ApiService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<{{EntityName}}[]> {
    return this.http.get<{{EntityName}}[]>('/api/v1/{{entity-name}}s');
  }

  create(data: Partial<{{EntityName}}>): Observable<{{EntityName}}> {
    return this.http.post<{{EntityName}}>('/api/v1/{{entity-name}}s', data);
  }

  update(id: string, data: Partial<{{EntityName}}>): Observable<{{EntityName}}> {
    return this.http.put<{{EntityName}}>(`/api/v1/{{entity-name}}s/${id}`, data);
  }

  delete(ids: string[]): Observable<void> {
    return this.http.request<void>('delete', '/api/v1/{{entity-name}}s', {
      body: { ids }
    });
  }
}
```

### 2. Dialog Component (選擇性)

**{{entity-name}}-dialog.component.ts** - 用於 Create/Edit

參考：`.claude/templates/form-dialog/`

## 自訂化

### 調整 Table Columns

修改 `tableColumns` 陣列：

```typescript
protected readonly tableColumns: TableColumn[] = [
  { key: SELECT_COLUMN_KEY },
  { key: EDIT_COLUMN_KEY },
  { key: 'name', header: 'pages.{{domain-name}}.{{entity-name}}.name' },
  { key: 'modelSeries', header: 'pages.{{domain-name}}.{{entity-name}}.modelSeries' },
  { key: 'version', header: 'pages.{{domain-name}}.{{entity-name}}.version' },
  {
    key: 'status',
    header: 'pages.{{domain-name}}.{{entity-name}}.status',
    isCustomTemplate: true  // 使用自訂 template
  }
];
```

### 加入自訂 Column Template

在 HTML 中加入：

```html
<one-ui-common-table ...>
  <!-- ... toolbar templates ... -->

  <!-- Custom column template -->
  <ng-template #tableColumnsTemplate>
    <ng-container matColumnDef="status">
      <th mat-header-cell *matHeaderCellDef>Status</th>
      <td mat-cell *matCellDef="let row">
        <mx-status
          [statusType]="row.status ? 'success' : 'neutral'"
          [statusText]="row.status ? 'Active' : 'Inactive'"
        ></mx-status>
      </td>
    </ng-container>
  </ng-template>
</one-ui-common-table>
```

### 條件式禁用 Select/Edit

```typescript
protected readonly tableColumns: TableColumn[] = [
  {
    key: SELECT_COLUMN_KEY,
    disable: (row: {{EntityName}}): boolean => {
      // 禁用特定條件的 row
      return row.status === 'locked';
    },
    rowTooltip: (row: {{EntityName}}): string => {
      return row.status === 'locked' ? 'This item is locked' : '';
    }
  },
  {
    key: EDIT_COLUMN_KEY,
    disable: (row: {{EntityName}}): boolean => {
      // 禁用編輯按鈕
      return !this.isMainLicenseValid() || row.readOnly;
    }
  },
  // ... other columns
];
```

## 完整範例

參考專案中的實作：
- `libs/mxsecurity/system/features/src/lib/user-account/`
- `libs/mxsecurity/license/features/src/lib/license/`

## Checklist

使用此範本後確認：

- [ ] ✅ Entity model 已定義
- [ ] ✅ API Service 已實作
- [ ] ✅ TableColumns 已調整
- [ ] ✅ i18n keys 已加入
- [ ] ✅ Dialog component 已建立
- [ ] ✅ Component 已加入 routes
- [ ] ✅ 測試已撰寫
- [ ] ✅ 無 ESLint 錯誤
