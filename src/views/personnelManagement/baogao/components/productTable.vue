// 子组件
<template>
  <div>
    <vxe-toolbar>
      <template #buttons>
        <el-button
          icon="el-icon-circle-plus-outline"
          type="success"
          @click="insertEvent(-1)"
        >
          新增
        </el-button>
        <el-button icon="el-icon-delete" type="danger" @click="removeEvent">
          移除
        </el-button>
        <el-button icon="el-icon-message" type="info" @click="saveEvent">
          保存
        </el-button>
        <el-button
          icon="el-icon-refresh-left"
          type="warning"
          @click="revertEvent"
        >
          还原
        </el-button>
      </template>
    </vxe-toolbar>

    <vxe-table
      ref="xTable"
      border
      resizable
      show-overflow
      keep-source
      :row-config="{ isHover: true }"
      :loading="loading"
      :data="tableData"
      :edit-config="{ trigger: 'click', mode: 'row' }"
    >
      <vxe-column type="checkbox" width="50"></vxe-column>
      <vxe-column type="seq" width="60"></vxe-column>
      <vxe-column
        field="ZG_BiaoTi"
        :title="item1"
        :edit-render="{}"
        width="120"
      >
        <template #edit="{ row }">
          <vxe-input v-model="row.ZG_BiaoTi" type="text"></vxe-input>
        </template>
      </vxe-column>
      <vxe-column
        field="ZG_YaoQiu"
        :title="item2"
        :edit-render="{}"
        width="120"
      >
        <template #edit="{ row }">
          <vxe-input
            v-if="typeData != 'buhege'"
            v-model="row.ZG_YaoQiu"
            type="text"
          ></vxe-input>
          <vxe-select
            v-if="typeData == 'buhege'"
            v-model="row.ZG_YaoQiu"
            placeholder="不合格类型"
            clearable
          >
            <vxe-option
              v-for="num in buhegeType"
              :key="num"
              :value="num"
              :label="num"
            ></vxe-option>
          </vxe-select>
        </template>
      </vxe-column>
      <vxe-column field="ZG_LuoShi" :title="item3" :edit-render="{}">
        <template #edit="{ row }">
          <vxe-textarea
            v-model="row.ZG_LuoShi"
            type="text"
            row="3"
          ></vxe-textarea>
        </template>
      </vxe-column>
      <vxe-column field="ZG_BeiZhu" :title="item4" :edit-render="{}">
        <template #edit="{ row }">
          <vxe-textarea
            v-model="row.ZG_BeiZhu"
            type="text"
            row="3"
          ></vxe-textarea>
        </template>
      </vxe-column>
      <vxe-column title="操作" width="160">
        <template #default="{ row }">
          <template v-if="$refs.xTable.isActiveByRow(row)">
            <vxe-button @click="saveRowEvent(row)">保存</vxe-button>
            <vxe-button @click="cancelRowEvent(row)">取消</vxe-button>
          </template>
          <template v-else>
            <vxe-button
              icon="vxe-icon-edit"
              type="text"
              @click="editRowEvent(row)"
            ></vxe-button>
            <vxe-button
              type="text"
              icon="vxe-icon-delete"
              @click="removeEventRow(row)"
            ></vxe-button>
          </template>
        </template>
      </vxe-column>
    </vxe-table>
  </div>
</template>
<script>
  import VXETable from 'vxe-table'

  export default {
    props: {
      proptableData: {
        type: Array,
        default: () => [], //如果不传值，则为default的值
      },
      typeData: {
        type: String,
        default: 'buhege',
      },
    },
    data() {
      return {
        /// vex-table
        buhegeType: ['不符', '基本'],
        item1: () => {
          switch (this.typeData) {
            case 'buhege':
              return '不符合项'
              break
            case 'hegeProduct':
              return '产品编号'
              break
            case 'buhegeProduct':
              return '登记号'
              break
            case 'qianciZhenggai':
              return '条款编号'
              break
            default:
              return ''
              break
          }
        },
        item2: () => {
          switch (this.typeData) {
            case 'buhege':
              return '不合格类型'
              break
            case 'hegeProduct':
              return '产品名称'
              break
            case 'buhegeProduct':
              return '产品名称'
              break
            case 'qianciZhenggai':
              return '整改要求'
              break
            default:
              return ''
              break
          }
        },
        item3: () => {
          switch (this.typeData) {
            case 'buhege':
              return '不合格事实'
              break
            case 'hegeProduct':
              return '产品型号'
              break
            case 'buhegeProduct':
              return '产品型号'
              break
            case 'qianciZhenggai':
              return '落实情况'
              break
            default:
              return ''
              break
          }
        },
        item4: () => {
          switch (this.typeData) {
            case 'buhege':
              return '整改要求'
              break
            case 'hegeProduct':
              return '规格范围'
              break
            case 'buhegeProduct':
              return '规格范围'
              break
            case 'qianciZhenggai':
              return '备注'
              break
            default:
              return ''
              break
          }
        },
        loading: false,
        submitLoading: false,
        tableData: this.proptableData,
        selectRow: null,
        /// vex-table
        showEdit_4: false,
        formData: {
          ZG_BiaoTi: null,
          ZG_YaoQiu: null,
          ZG_LuoShi: null,
          ZG_BeiZhu: null,
        },
        formRules: {
          // ZG_BiaoTi: [
          //   { required: true, message: '请输入名称' },
          //   { min: 3, max: 5, message: '长度在 3 到 5 个字符' },
          // ],
          // ZG_BeiZhu: [{ required: true, message: '请输入昵称' }],
        },
      }
    },
    methods: {
      /// vex-table所用方法
      popData() {
        return this.tableData
      },
      sortNameMethod2({ row }) {
        // 按名称长度进行排序
        return row.ZG_BiaoTi.slice(0, row.ZG_BiaoTi.indexOf('.'))
      },
      visibleMethod({ data }) {
        return data.flag1 === 'Y'
      },
      cellDBLClickEvent({ row }) {
        this.editEvent(row)
      },
      insertEvent(row) {
        this.formData = {
          ZG_BiaoTi: '',
          ZG_YaoQiu: '',
          ZG_LuoShi: '',
          ZG_BeiZhu: '',
        }
        this.$refs.xTable.insert(this.formData, -1)
      },
      editRowEvent(row) {
        const $table = this.$refs.xTable
        $table.setActiveRow(row)
      },
      editEvent(row) {
        this.formData = {
          ZG_BiaoTi: row.ZG_BiaoTi,
          ZG_YaoQiu: row.ZG_YaoQiu,
          ZG_LuoShi: row.ZG_LuoShi,
          ZG_BeiZhu: row.ZG_BeiZhu,
        }
        this.selectRow = row
      },

      async removeEventRow(row) {
        const type = await VXETable.modal.confirm('您确定要删除该数据?')
        const $table = this.$refs.xTable
        if (type === 'confirm') {
          $table.remove(row)
        }
      },
      submitEvent() {
        this.submitLoading = true
        setTimeout(() => {
          const $table = this.$refs.xTable
          this.submitLoading = false
          if (this.selectRow) {
            VXETable.modal.message({ content: '保存成功', status: 'success' })
            Object.assign(this.selectRow, this.formData)
          } else {
            VXETable.modal.message({ content: '新增成功', status: 'success' })
            $table.insert(this.formData, -1)
          }
        }, 500)
      },
      async removeEvent() {
        const $table = this.$refs.xTable
        const selectRecords = $table.getCheckboxRecords()
        if (selectRecords.length) {
          const type = await VXETable.modal.confirm('您确定要删除选中的数据吗?')
          if (type === 'confirm') {
            $table.removeCheckboxRow()
          }
        } else {
          VXETable.modal.message({
            content: '请至少选择一条数据',
            status: 'error',
          })
        }
      },
      async revertEvent() {
        const type = await VXETable.modal.confirm('您确定要还原数据吗?')
        const $table = this.$refs.xTable
        if (type === 'confirm') {
          $table.revertData()
        }
      },
      saveEvent() {
        const $table = this.$refs.xTable
        const { insertRecords, removeRecords, updateRecords } =
          $table.getRecordset()
        console.log(insertRecords)
        console.log(removeRecords)
        console.log(updateRecords)
        if (insertRecords.length > 0) this.tableData.push(...insertRecords)
        let _ids = []
        if (removeRecords.length > 0) {
          removeRecords.forEach((item) => {
            _ids.push(item)
            this.tableData.map((Item, index) => {
              console.log(Item._X_ROW_KEY)
              console.log(item._X_ROW_KEY)
              if (Item._X_ROW_KEY === item._X_ROW_KEY)
                this.tableData.splice(index, 1)
            })
          })
        }
        if (updateRecords.length > 0) {
          updateRecords.forEach((item) => {
            _ids.push(item)
            this.tableData.map((Item, index) => {
              console.log(Item._X_ROW_KEY)
              console.log(item._X_ROW_KEY)
              if (Item._X_ROW_KEY === item._X_ROW_KEY)
                this.tableData.splice(index, 1, item)
            })
          })
        }

        console.log('this.tableData')
        console.log(_ids)
        console.log(this.tableData)

        VXETable.modal.message({
          content: `保存成功，插入数据${insertRecords.length} 条，删除${removeRecords.length} 条，更新${updateRecords.length}条`,
          status: 'success',
        })
      },
      saveRowEvent() {
        const $table = this.$refs.xTable
        $table.clearActived().then(() => {
          this.loading = true
          setTimeout(() => {
            this.loading = false
            VXETable.modal.message({ content: '保存成功！', status: 'success' })
          }, 300)
        })
      },
      cancelRowEvent(row) {
        const $table = this.$refs.xTable
        $table.clearActived().then(() => {
          // 还原行数据
          $table.revertData(row)
        })
      },
    },
  }
</script>
