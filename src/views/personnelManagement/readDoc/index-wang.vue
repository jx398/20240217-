<template>
  <div style="border: 1px solid #ccc">
    <Toolbar
      style="border-bottom: 1px solid #ccc"
      :editor="editor"
      :defaultConfig="toolbarConfig"
      :mode="mode"
    />
    <Editor
      v-model="html"
      style="height: 500px; overflow-y: hidden"
      :defaultConfig="editorConfig"
      :mode="mode"
      @onCreated="onCreated"
    />
  </div>
</template>
<script>
  import Vue from 'vue'
  import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
  import '@wangeditor/editor/dist/css/style.css'

  export default Vue.extend({
    components: { Editor, Toolbar },
    data() {
      return {
        editor: null,
        html: '<p>hello</p>',
        toolbarConfig: {},
        editorConfig: { placeholder: '请输入内容...' },
        mode: 'default', // or 'simple'
      }
    },
    mounted() {
      // 模拟 ajax 请求，异步渲染编辑器
      setTimeout(() => {
        this.html =
          '<p><strong>不符合（基本符合）事实描述及整改要求表</strong></p><table><tr><td><p><strong>序号</strong></p></td><td><p><strong>条款编号</strong></p></td><td><p><strong>评审结果及不符合（基本符合）</strong></p><p><strong>事实描述</strong></p></td><td><p><strong>整改要求</strong></p></td></tr><tr><td><p>1</p></td><td><p><strong>7.1</strong>②</p></td><td><p>■基本符合</p><p>合格供方质量档案信息收集不齐全，未收集部分合格供应商（如青州厚深工程机械有限公司、山东科远汽车尾气净化系统有限公司）的营业执照等信息。   </p></td><td><p>完善合格供方的档案，收集资料合格供应商（如青州厚深工程机械有限公司、山东科远汽车尾气净化系统有限公司）的营业执照。</p></td></tr><tr><td><p>2</p></td><td><p><strong>7.1</strong>④</p></td><td><p>■基本符合</p><p>采购合同未明确相关技术要求、验收标准。   </p></td><td><p>加强合同评审，提供一份明确提出质量标准要求的采购合同。</p></td></tr><tr><td><p>3</p></td><td><p><strong>7.1</strong>②</p></td><td><p>■基本符合</p><p>合格供方质量档案信息收集不齐全，未收集部分合格供应商（如青州厚深工程机械有限公司、山东科远汽车尾气净化系统有限公司）的营业执照等信息。   </p></td><td><p>完善合格供方的档案，收集资料合格供应商（如青州厚深工程机械有限公司、山东科远汽车尾气净化系统有限公司）的营业执照。</p></td></tr><tr><td><p>4</p></td><td><p><strong>7.2</strong>②</p></td><td><p>■基本符合</p><p>合格外协方名录不全，未包含（济南市莱芜惠泽机械制造有限公司）。合格外协方质量档案信息收集不齐全，未收集部分合格外协方的营业执照等信息。    </p></td><td><p>完善合格外协方名录，收集完善合格外协方质量档案。</p></td></tr><tr><td><p>5</p></td><td><p><strong>7.2</strong>③</p></td><td><p>■基本符合</p><p>未对济南市莱芜惠泽机械制造有限公司进行能力验证。  </p></td><td><p>对济南市莱芜惠泽机械制造有限公司进行供方评价。</p></td></tr><tr><td><p>6</p></td><td><p><strong>7.2</strong>④</p></td><td><p>■基本符合</p><p>未在外协加工合同中明确质量要求。    </p></td><td><p>加强合同评审，提供一份明确提出质量标准要求的外协供货合同。</p></td></tr><tr><td><p>7</p></td><td><p><strong>8.2</strong>③</p></td><td><p>■基本符合</p><p>无油缸装配工装验证记录。</p></td><td><p>对油缸装配工装进行工装验证，自查对未进行验证的其他工装进行工装验证。</p></td></tr><tr><td><p>8</p></td><td><p><strong>9.4</strong>②</p></td><td><p>■基本符合</p><p>未制定针对具体外协件（如散热器总成、整车线束）的检验要求。</p></td><td><p>完善外协件检验规程，明确具体外协件的检验要求。</p></td></tr><tr><td><p>9</p></td><td><p><strong>9.4</strong>③</p></td><td><p>■不符合</p><p>无焊接关键工序检验规程。</p></td><td><p>制定焊接关键工序检验规程。</p></td></tr><tr><td><p>10</p></td><td><p><strong>10.2</strong></p></td><td><p>■不符合</p><p>未设置不合格品区，对采购环节的不合格品（制动器壳体）未进行标识、有效隔离，无不合格品处置记录。</p></td><td><p>加强不合格管理，对不合格品进行标识、有效隔离，建立无不合格品处置记录，划定不合格品区。</p></td></tr><tr><td><p>11</p></td><td><p>10.3</p></td><td><p>■不符合</p><p>未收集整理不合格品（制动器壳体）信息、产生原因、纠正措施和预防措施及跟踪验证。</p></td><td><p>加强不合格管理，对不合格品产生原因进行分析，制定、实施并验证纠正措施。</p></td></tr></table>'
      }, 1500)
    },
    beforeDestroy() {
      const editor = this.editor
      if (editor == null) return
      editor.destroy() // 组件销毁时，及时销毁编辑器
    },
    methods: {
      onCreated(editor) {
        this.editor = Object.seal(editor) // 一定要用 Object.seal() ，否则会报错
      },
    },
  })
</script>
