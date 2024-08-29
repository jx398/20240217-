<template>
  <div>
    <vxe-toolbar>
      <template #buttons>
        <!-- <vxe-form :data="formData" @submit="submitEvent" @reset="resetSearch">
          <vxe-form-item title="名称" field="name" :item-render="{}">
            <template #default="{ data }">
              <vxe-input
                v-model="data.name"
                placeholder="请输入标准号"
                clearable
                @clear="resetSearch"
              ></vxe-input>
            </template>
          </vxe-form-item>

          <vxe-form-item
            title="一级类别"
            field="levelOne"
            :item-render="{}"
            :title-prefix="{ messlevelOne: '帮助信息！！！' }"
          >
            <template #default="{ data }">
              <vxe-input
                v-model="data.levelOne"
                placeholder="请输入名称"
                clearable
                @clear="resetSearch"
              ></vxe-input>
            </template>
          </vxe-form-item>
          <vxe-form-item
            title="二级类别"
            field="levelTwo"
            :item-render="{}"
            :title-prefix="{ messlevelTwo: '帮助信息！！！' }"
          >
            <template #default="{ data }">
              <vxe-input
                v-model="data.levelTwo"
                placeholder="请输入名称"
                clearable
                @clear="resetSearch"
              ></vxe-input>
            </template>
          </vxe-form-item>

          <vxe-form-item
            title="三级类别"
            field="levelThree"
            :item-render="{}"
            :title-prefix="{ messlevelThree: '帮助信息！！！' }"
          >
            <template #default="{ data }">
              <vxe-input
                v-model="data.levelThree"
                placeholder="请输入名称"
                clearable
                @clear="resetSearch"
              ></vxe-input>
            </template>
          </vxe-form-item>
          <vxe-form-item
            title="设备名称"
            field="shebei"
            :item-render="{}"
            :title-prefix="{ messlevelTwo: '帮助信息！！！' }"
          >
            <template #default="{ data }">
              <vxe-input
                v-model="data.levelOne"
                placeholder="请输入名称"
                clearable
                @clear="resetSearch"
              ></vxe-input>
            </template>
          </vxe-form-item>

          <vxe-form-item>
            <template #default>
              <vxe-button type="submit" status="primary">查询</vxe-button>
            </template>
          </vxe-form-item>
        </vxe-form> -->

        <!-- <vxe-button @click="$refs.xTable.sort('name', 'asc')">
          Name 升序
        </vxe-button>
        <vxe-button @click="$refs.xTable.sort('name', 'desc')">
          Name 降序
        </vxe-button>
        <vxe-button @click="$refs.xTable.clearSort()">清除排序</vxe-button> -->

        <vxe-input
          v-model="filterName1"
          type="search"
          placeholder="试试全表搜索"
          clearable
          @keyup="searchEvent1"
          @clear="resetSearch"
        ></vxe-input>
        <vxe-button type="reset" @click="resetSearch">重置</vxe-button>
      </template>
    </vxe-toolbar>

    <vxe-table
      ref="xTable"
      height="900"
      highlight-hover-row
      highlight-current-row
      resizable
      border
      :row-config="{ isHover: true }"
      :data="list1"
      :loading="loading"
      :span-method="rowspanMethod"
      :seq-config="{
        startIndex: (tablePage.currentPage - 1) * tablePage.pageSize,
      }"
    >
      >
      <vxe-column type="seq" width="60"></vxe-column>
      <vxe-colgroup title="规范编号" type="html">
        <vxe-column field="name" type="html">
          <template #header="{ column }">
            <vxe-input
              v-model="sName"
              type="text"
              placeholder="请输入"
              :class="column"
              clearable
              @change="submitEvent()"
              @clear="resetSearch"
            ></vxe-input>
          </template>
          <template #default="{ row }">
            <el-link v-down="row.href">
              <span class="name" v-html="row.name"></span>
            </el-link>
          </template>
        </vxe-column>
      </vxe-colgroup>
      <vxe-colgroup title="设备名称" type="html">
        <vxe-column field="shebei" type="html">
          <template #header="{ column }">
            <vxe-input
              v-model="sshebei"
              type="text"
              placeholder="请输入"
              :class="column"
              clearable
              @change="submitEvent()"
              @clear="resetSearch"
            ></vxe-input>
          </template>
          <template #default="{ row }">
            <el-link @click="handleAdd(row.href)">
              <span class="link" v-html="row.shebei"></span>
            </el-link>
          </template>
        </vxe-column>
      </vxe-colgroup>

      <vxe-colgroup title="一级类别" type="html">
        <vxe-column field="levelOne" type="html">
          <template #header>
            <!-- <vxe-input
              v-model="slevelOne"
              type="text"
              placeholder="请输入"
              :size="{ column }"
              class="column"
              clearable
              autocomplete
              :autocomplete-options="autocompleteOptions"
              @change="submitEvent()"
              @clear="resetSearch"
            ></vxe-input> -->
            <el-select
              v-model="slevelOne"
              filterable
              clearable
              allow-create
              default-first-option
              style="width: 90%"
              placeholder="请输入一级分类名称"
              @change="submitEvent()"
              @clear="resetSearch"
            >
              <el-option
                v-for="item in autocompleteOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              ></el-option>
            </el-select>
          </template>
        </vxe-column>
      </vxe-colgroup>
      <vxe-colgroup title="二级类别" type="html">
        <vxe-column field="levelTwo" type="html">
          <template #header>
            <el-select
              v-model="slevelTwo"
              filterable
              clearable
              allow-create
              default-first-option
              style="width: 90%"
              placeholder="请输入二级分类名称"
              @change="submitEvent()"
              @clear="resetSearch"
            >
              <el-option
                v-for="item in erjiOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              ></el-option>
            </el-select>
          </template>
        </vxe-column>
      </vxe-colgroup>
      <vxe-colgroup title="三级类别" type="html">
        <vxe-column field="levelThree" type="html">
          <template #header>
            <el-select
              v-model="slevelThree"
              filterable
              clearable
              allow-create
              default-first-option
              style="width: 90%"
              placeholder="请输入三级分类名称"
              @change="submitEvent()"
              @clear="resetSearch"
            >
              <el-option
                v-for="item in sanjiOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              ></el-option>
            </el-select>
          </template>
        </vxe-column>
      </vxe-colgroup>
    </vxe-table>
    <div>
      <vxe-pager
        :layouts="[
          'Sizes',
          'PrevJump',
          'PrevPage',
          'Number',
          'NextPage',
          'NextJump',
          'FullJump',
          'Total',
        ]"
        :current-page.sync="tablePage.currentPage"
        :page-size.sync="tablePage.pageSize"
        :total="tablePage.total"
        @page-change="handlePageChange"
      ></vxe-pager>
    </div>
    <mypdfView ref="edit"></mypdfView>
  </div>
</template>

<script>
  import XEUtils from 'xe-utils'
  import { parse } from 'node-html-parser'
  import { GUIFAN, BIAOZHUN } from './constdata.js'
  import mypdfView from './components/mypdfView'
  import '@/plugins/vdown'
  import { YIJI, ERJI, SANJI } from './leibie'

  export default {
    components: { mypdfView },

    data() {
      return {
        list1: [],
        sName: '',
        slevelOne: '',
        slevelTwo: '',
        slevelThree: '',
        sshebei: '',
        formData: { name: '', levelOne: '' },
        tablePage: {
          total: 0,
          currentPage: 1,
          pageSize: 20,
        },
        tableData: [],
        isChronological4: false,
        filterName1: '',
        loading: false,
        searchData: [],
        autocompleteOptions: YIJI,
        erjiOptions: ERJI,
        sanjiOptions: SANJI,
        TABLEDATA: this.$route.name == 'guifan' ? GUIFAN : BIAOZHUN,
      }
    },
    created() {
      this.searchData = []
      this.fetchData()
    },
    methods: {
      handleAdd(_url) {
        console.log('passed_url')
        console.log(_url)
        this.$refs['edit'].showEdit(_url)
      },

      customStringFilterMethod({ option, row, column }) {
        if (option.data) {
          return (
            XEUtils.toValueString(row[column.property])
              .toLowerCase()
              .indexOf(option.data) > -1
          )
        }
        return true
      },
      filterEvent(option) {
        const xTable = this.$refs.xTable
        // 设置为选中状态
        option.checked = true
        // 修改条件之后，需要手动调用 updateData 处理表格数据
        xTable.updateData()
      },
      fetchData() {
        this.loading = true
        if (this.searchData.length == 0) {
          this.tablePage.total = this.TABLEDATA.length
          this.list1 = this.TABLEDATA.slice(
            (this.tablePage.currentPage - 1) * this.tablePage.pageSize,
            this.tablePage.currentPage * this.tablePage.pageSize
          )
        } else {
          this.tablePage.total = this.searchData.length
          this.list1 = this.searchData.slice(
            (this.tablePage.currentPage - 1) * this.tablePage.pageSize,
            this.tablePage.currentPage * this.tablePage.pageSize
          )
        }
        this.loading = false
      },
      submitEvent() {
        console.log(this.formData)
        console.log('submit')
        // Object.keys(this.formData).forEach((item) => {
        //   console.log(item, this.formData[item])
        //   this.searchFun([item], this.formData[item])
        //   console.log(this.list1)
        // })

        this.searchFun(['name'], this.sName)
          .searchFun(['levelOne'], this.slevelOne)
          .searchFun(['levelTwo'], this.slevelTwo)
          .searchFun(['levelThree'], this.slevelThree)
          .searchFun(['shebei'], this.sshebei)
        this.fetchData()
      },

      resetSearch() {
        // this.list1 = this.tableData
        // this.searchFun(['name'], this.formData.name).searchFun(
        //   ['levelOne'],
        //   this.formData.levelOne
        // )
        console.log(this.searchData)
        this.searchData = []
        // this.sName = ''
        // this.slevelOne = ''
        // this.slevelTwo = ''
        // this.slevelThree = ''
        this.submitEvent()
        this.fetchData()
      },

      handlePageChange({ currentPage, pageSize }) {
        this.tablePage.currentPage = currentPage
        this.tablePage.pageSize = pageSize
        this.fetchData()
      },
      searchEvent1() {
        this.searchFun(
          ['name', 'levelOne', 'levelTwo', 'levelThree', 'shebei'],
          this.filterName1
        )
      },
      searchFun(_scope, _content) {
        console.log(_scope, _content)
        const _filterName = XEUtils.toValueString(_content).trim().toLowerCase()
        if (_filterName) {
          const _filterRE = new RegExp(_filterName, 'gi')
          const _searchProps = _scope
          const _rest = this.TABLEDATA.filter((item) =>
            _searchProps.some(
              (key) =>
                parse(XEUtils.toValueString(item[key]))
                  .text.toString()
                  .toLowerCase()
                  .indexOf(_filterName) > -1
            )
          )
          this.searchData = _rest.map((row) => {
            const _item = Object.assign({}, row)
            _searchProps.forEach((key) => {
              _item[key] = parse(XEUtils.toValueString(_item[key]))
                .text.toString()
                .replace(
                  _filterRE,
                  (match) => `<span class="keyword-lighten">${match}</span>`
                )
            })
            return _item
          })
          console.log(this.searchData)
          this.list1 = this.searchData.slice(
            (this.tablePage.currentPage - 1) * this.tablePage.pageSize,
            this.tablePage.currentPage * this.tablePage.pageSize
          )
          this.tablePage = {
            total: this.searchData.length,
            currentPage: 1,
            pageSize: 20,
          }
        } else {
          //this.list1 = this.tableData
        }
        return this
      },
      searchFunList(_scope, _content) {
        console.log(_scope, _content)
        const _filterName = XEUtils.toValueString(_content).trim().toLowerCase()
        if (_filterName) {
          const _filterRE = new RegExp(_filterName, 'gi')
          const _searchProps = _scope
          const _rest = this.list1.filter((item) =>
            _searchProps.some(
              (key) =>
                parse(XEUtils.toValueString(item[key]))
                  .text.toString()
                  .toLowerCase()
                  .indexOf(_filterName) > -1
            )
          )
          this.searchData = _rest.map((row) => {
            const _item = Object.assign({}, row)
            _searchProps.forEach((key) => {
              _item[key] = parse(XEUtils.toValueString(_item[key]))
                .text.toString()
                .replace(
                  _filterRE,
                  (match) => `<span class="keyword-lighten">${match}</span>`
                )
            })
            return _item
          })
          console.log(this.searchData)
          this.list1 = this.searchData.slice(
            (this.tablePage.currentPage - 1) * this.tablePage.pageSize,
            this.tablePage.currentPage * this.tablePage.pageSize
          )
          this.tablePage = {
            total: this.searchData.length,
            currentPage: 1,
            pageSize: 10,
          }
        } else {
          //this.list1 = this.tableData
        }
        return this
      },
      formatterNum2({ cellValue }) {
        return XEUtils.commafy(XEUtils.toNumber(cellValue), { digits: 2 })
      },
      sortNameMethod2({ row }) {
        // 按名称长度进行排序
        return row.name.length
      },
      sortChangeEvent3({ sortList }) {
        console.info(
          sortList.map((item) => `${item.property},${item.order}`).join('; ')
        )
      },
      sortChangeEvent4({ property, order }) {
        console.info(property, order)
      },
      getPinYin(str) {
        return str
          .split('')
          .map((char) => {
            switch (char.charAt(0)) {
              case '老':
                return 'lao'
              case '小':
                return 'xiao'
              case '前':
                return 'qian'
              case '好':
                return 'hao'
              case '王':
                return 'wang'
              case '红':
                return 'hong'
              case '明':
                return 'ming'
              case '吧':
                return 'ba'
              case '踢':
                return 'ti'
            }
            return char.charAt(0)
          })
          .join('')
      },
      customSortMethod({ data, sortList }) {
        const sortItem = sortList[0]
        // 取出第一个排序的列
        const { property, order } = sortItem
        let list = []
        if (order === 'asc' || order === 'desc') {
          if (property === 'name') {
            // 例如：实现中英文混排，按照字母排序
            list = data.sort((a, b) => {
              return this.getPinYin(a.name).localeCompare(
                this.getPinYin(b.name)
              )
            })
          } else {
            list = data.sort()
          }
        }
        if (order === 'desc') {
          list.reverse()
        }
        return list
      },
      filterVisibleEvent({ column, visible }) {
        console.log(`${column.property} ${visible ? '打开' : '关闭'}筛选面板`)
      },
      filterChangeEvent({ column }) {
        console.log(`${column.property} 筛选了数据`)
      },
      filterNameMethod({ option, row }) {
        return row.name.indexOf(option.data) > -1
      },
      filterlevelOneMethod({ option, row }) {
        return row.levelOne.indexOf(option.data) > -1
      },
      filterlevelTwoMethod({ option, row }) {
        return row.levelTwo.indexOf(option.data) > -1
      },

      filterlevelThreeMethod({ option, row }) {
        return row.levelThree.indexOf(option.data) > -1
      },

      filtershebeiMethod({ option, row }) {
        return row.shebei.indexOf(option.data) > -1
      },

      // 通用行合并函数（将相同多列数据合并为一行）
      rowspanMethod({ row, _rowIndex, column, visibleData }) {
        const fields = ['name']
        const cellValue = row[column.property]
        if (cellValue && fields.includes(column.property)) {
          const prevRow = visibleData[_rowIndex - 1]
          let nextRow = visibleData[_rowIndex + 1]
          if (prevRow && prevRow[column.property] === cellValue) {
            return { rowspan: 0, colspan: 0 }
          } else {
            let countRowspan = 1
            while (nextRow && nextRow[column.property] === cellValue) {
              nextRow = visibleData[++countRowspan + _rowIndex]
            }
            if (countRowspan > 1) {
              return { rowspan: countRowspan, colspan: 1 }
            }
          }
        }
      },
    },
  }
</script>
<style>
  .column {
    width: 80%;
  }
  .name {
    color: rgb(43, 81, 231);
  }
  .link {
    color: rgb(156, 9, 9);
  }
  .keyword-lighten {
    color: #000;
    background-color: #ffff00;
  }
  .type--search {
    width: 600px;
  }
</style>
