import Vue from 'vue'
import App from './App'
import store from './store'
import router from './router'
import './plugins'
import '@/layouts/export'
import vueFilePreview from 'gxd-file-preview'
import VueAudio from 'vue-audio-better'
import EleImport from 'vue-ele-import'
import VXETable from 'vxe-table'
import CKEditor from '@ckeditor/ckeditor5-vue2'

import 'vxe-table/lib/style.css'
/**npm  import '@electron/remote/main'
/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 生产环境默认都使用mock，如果正式用于生产环境时，记得去掉
 */

if (process.env.NODE_ENV === 'production') {
  const { mockXHR } = require('@/utils/static')
  mockXHR()
}
Vue.config.productionTip = false
//require('@electron/remote/main').initialize()

new Vue({
  el: '#vue-admin-beautiful',
  router,
  store,
  render: (h) => h(App),
})

//初始化自定义插件，（pdf.js,worker.js文件建议放在本地服务器),cdn有可能不稳定
Vue.use(vueFilePreview, {
  pdf: 'https://cdn.jsdelivr.net/npm/pdfjs-dist@2.0.288/build/pdf.min.js', //pdf插件
  worker:
    'https://cdn.jsdelivr.net/npm/pdfjs-dist@2.0.288/build/pdf.worker.min.js', //pdf.work插件
})
Vue.use(VueAudio)
Vue.use(EleImport).use(VXETable)
Vue.use(CKEditor)

Vue.component(EleImport.name, EleImport)
Vue.prototype.$t = () => {}

Vue.directive('down', {
  inserted: (el, binding) => {
    el.addEventListener('click', () => {
      let link = document.createElement('a')
      let url = binding.value
      // 这里是将url转成blob地址，
      fetch(url)
        .then((res) => res.blob())
        .then((blob) => {
          // 将链接地址字符内容转变成blob地址
          link.href = URL.createObjectURL(blob)
          console.log(link.href)
          link.download = ''
          document.body.appendChild(link)
          link.click()
        })
    })
  },
})
