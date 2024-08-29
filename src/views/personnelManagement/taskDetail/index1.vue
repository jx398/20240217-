<template>
  <div>
    <div style="margin-bottom: 20px">
      <el-button size="small" @click="addTab(1)">add tab</el-button>
      <el-button size="small" @click="addTab(2)">add tab</el-button>
      <el-button size="small" @click="addTab(3)">add tab</el-button>
      <el-button size="small" @click="addTab(4)">add tab</el-button>
      <el-button size="small" @click="addTab(5)">add tab</el-button>
    </div>
    <el-tabs v-model="editableTabsValue" type="card" closable>
      <el-tab-pane name="tab1" label="tab1"></el-tab-pane>
      <el-tab-pane name="tab2" label="tab2"></el-tab-pane>
      <el-tab-pane name="tab3" label="tab2"></el-tab-pane>
      <el-tab-pane name="tab4" label="tab2"></el-tab-pane>
      <el-tab-pane name="tab5" label="tab2"></el-tab-pane>
      <el-tab-pane name="tab6" label="tab2"></el-tab-pane>
      <el-tab-pane name="tab7" label="tab2"></el-tab-pane>
      <el-tab-pane name="tab8" label="tab2"></el-tab-pane>
      <el-tab-pane name="tab9" label="tab2"></el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
  export default {
    data() {
      return {
        editableTabsValue: 'tab4',
      }
    },
    methods: {
      addTab(v) {
        this.editableTabsValue = 'tab' + v
      },
    },
  }
</script>
