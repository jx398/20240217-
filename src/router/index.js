/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description router全局配置，如有必要可分文件抽离，其中asyncRoutes只有在intelligence模式下才会用到，vip文档中已提供路由的基础图标与小清新图标的配置方案，请仔细阅读
 */

import Vue from 'vue'
import VueRouter from 'vue-router'
import Layout from '@/layouts'
import EmptyLayout from '@/layouts/EmptyLayout'
import { publicPath, routerMode } from '@/config'

Vue.use(VueRouter)
export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true,
  },
  {
    path: '/register',
    component: () => import('@/views/register/index'),
    hidden: true,
  },
  {
    path: '/error/401',
    name: '401',
    component: () => import('@/views/error/401'),
    hidden: true,
  },
  {
    path: '/error/404',
    name: '404',
    component: () => import('@/views/error/404'),
    hidden: true,
  },
]

export const asyncRoutes = [
  {
    path: '/',
    component: Layout,
    redirect: '/index',
    children: [
      {
        path: 'index',
        name: 'Index',
        component: () => import('@/views/index/index'),
        meta: {
          title: '首页',
          icon: 'home',
          affix: true,
        },
      },
    ],
  },
  /* {
      path: "/test",
      component: Layout,
      redirect: "noRedirect",
      children: [
        {
          path: "test",
          name: "Test",
          component: () => import("@/views/test/index"),
          meta: {
            title: "test",
            icon: "marker",
            permissions: ["admin"],
          },
        },
      ],
    }, */

  {
    path: '/personnelManagement',
    component: Layout,
    redirect: 'noRedirect',
    name: 'PersonnelManagement',
    alwaysShow: true,
    meta: {
      title: '评审任务管理',
      icon: 'flask',
      permissions: ['admin'],
    },
    children: [
      {
        path: 'taskManagement',
        name: 'TaskManagement',
        component: () =>
          import('@/views/personnelManagement/taskManagement/index'),
        meta: {
          title: '任务管理',
          icon: 'briefcase',
        },
      },
      {
        path: 'factoryManagement',
        name: 'FactoryManagement',
        component: () =>
          import('@/views/personnelManagement/factoryManagement/index'),
        meta: {
          title: '工厂信息',
          icon: 'users-cog',
        },
      },
      {
        path: 'userManagement',
        name: 'UserManagement',
        component: () =>
          import('@/views/personnelManagement/userManagement/index'),
        meta: {
          title: '专业人员',
          icon: 'people-carry',
        },
      },
      {
        path: 'shebeiManagement',
        name: 'shebeiManagement',
        component: () =>
          import('@/views/personnelManagement/shebeiManagement/index'),
        meta: {
          title: '生产设备',
          icon: 'drafting-compass',
        },
      },
      {
        path: 'jianceManagement',
        name: 'jianceManagement',
        component: () =>
          import('@/views/personnelManagement/jianceManagement/index'),
        meta: {
          title: '检测设备',
          icon: 'coins',
        },
      },
    ],
  },
  {
    path: '/personnelManagement/taskDetail',
    component: Layout,
    redirect: '/personnelManagement/taskDetail',
    children: [
      {
        path: '/personnelManagement/taskDetail',
        name: 'taskDetail',
        component: () => import('@/views/personnelManagement/taskDetail'),
        meta: {
          title: '评审记录',
          icon: 'paperclip',
          affix: true,
        },
      },
    ],
  },
  {
    path: '/personnelManagement/buhegeDetail',
    component: Layout,
    redirect: '/personnelManagement/buhegeDetail',
    children: [
      {
        path: '/personnelManagement/buhegeDetail',
        name: 'buhegeDetail',
        component: () => import('@/views/personnelManagement/buhegeDetail'),
        meta: {
          title: '不合格报告',
          icon: 'eye',
          affix: true,
        },
      },
    ],
  },
  {
    path: '/personnelManagement/baogao',
    component: Layout,
    redirect: '/personnelManagement/baogao',
    children: [
      {
        path: '/personnelManagement/baogao',
        name: 'baogao',
        component: () => import('@/views/personnelManagement/baogao'),
        meta: {
          title: '评审报告',
          icon: 'rocket',
          affix: true,
        },
      },
    ],
  },
  {
    path: '/personnelManagement/pictures',
    component: Layout,
    redirect: 'noRedirect',
    name: 'pictures',
    alwaysShow: true,
    meta: {
      title: '现场图片',
      icon: 'camera',
    },
    children: [
      {
        path: 'shengchanxianchang',
        name: 'shengchanxianchang',
        meta: {
          title: '生产现场',
        },
        component: () => import('@/views/personnelManagement/pictures/index'),
      },
      {
        path: 'shengchanshebei',
        name: 'shengchanshebei',
        meta: {
          title: '生产设备',
        },
        component: () => import('@/views/personnelManagement/pictures/index'),
      },
      {
        path: 'jianceshebei',
        name: 'jianceshebei',
        meta: {
          title: '检测设备',
        },
        component: () => import('@/views/personnelManagement/pictures/index'),
      },
      {
        path: 'chuchangjianyan',
        name: 'chuchangjianyan',
        meta: {
          title: '出厂检验',
        },
        component: () => import('@/views/personnelManagement/pictures/index'),
      },
      {
        path: 'jishuliliang',
        name: 'jishuliliang',
        meta: {
          title: '技术力量',
        },
        component: () => import('@/views/personnelManagement/pictures/index'),
      },
      {
        path: 'zhutizige',
        name: 'zhutizige',
        meta: {
          title: '主体资格',
        },
        component: () => import('@/views/personnelManagement/pictures/index'),
      },
      {
        path: 'qiandao',
        name: 'qiandao',
        meta: {
          title: '签到表及录音',
        },
        component: () => import('@/views/personnelManagement/pictures/index'),
      },
    ],
  },
  {
    path: '/personnelManagement/ziliao',
    component: Layout,
    redirect: 'noRedirect',
    name: 'ziliao',
    alwaysShow: true,
    meta: {
      title: '参考资料',
      icon: 'book',
    },
    children: [
      {
        path: 'guifan',
        name: 'guifan',
        meta: {
          title: '现行规范',
        },
        component: () => import('@/views/personnelManagement/ziliao/index'),
      },
      {
        path: 'biaozhun',
        name: 'biaozhun',
        meta: {
          title: '标准文本',
        },
        component: () => import('@/views/personnelManagement/ziliao/index'),
      },
      {
        path: 'readDoc',
        name: 'readDoc',
        meta: {
          title: '读取word文档内容到vue-quill',
        },
        component: () => import('@/views/personnelManagement/readDoc/index'),
      },
      {
        path: 'fileView',
        name: 'fileView',
        meta: {
          title: '查看文件',
        },
        component: () => import('@/views/personnelManagement/fileView/index'),
      },
    ],
  },
  {
    path: '/error',
    component: Layout,
    redirect: 'noRedirect',
    name: 'error',
    alwaysShow: true,
    meta: {
      title: '测试页面',
      icon: 'car',
      permissions: ['admin'],
    },
    children: [
      {
        path: '/error/401',
        name: 'Error401',
        component: () => import('@/views/error/401'),
        meta: {
          title: '401',
        },
      },
      {
        path: '/error/404',
        name: 'Error404',
        component: () => import('@/views/error/404'),
        meta: {
          title: '404',
        },
      },
    ],
  },

  // {
  //   path: '/vab',
  //   component: Layout,
  //   redirect: 'noRedirect',
  //   name: 'Vab',
  //   alwaysShow: true,
  //   meta: { title: '组000件', icon: 'box-open' },
  //   children: [
  //     {
  //       path: 'permissions',
  //       name: 'Permission',
  //       component: () => import('@/views/vab/permissions/index'),
  //       meta: {
  //         title: '角色权限',
  //         permissions: ['admin', 'editor'],
  //       },
  //     },
  //     {
  //       path: 'icon',
  //       component: EmptyLayout,
  //       redirect: 'noRedirect',
  //       name: 'Icon',
  //       meta: {
  //         title: '图标',
  //         permissions: ['admin'],
  //       },
  //       children: [
  //         {
  //           path: 'awesomeIcon',
  //           name: 'AwesomeIcon',
  //           component: () => import('@/views/vab/icon/index'),
  //           meta: { title: '常规图标' },
  //         },
  //         {
  //           path: 'colorfulIcon',
  //           name: 'ColorfulIcon',
  //           component: () => import('@/views/vab/icon/colorfulIcon'),
  //           meta: { title: '多彩图标' },
  //         },
  //       ],
  //     },
  //     {
  //       path: 'table',
  //       component: () => import('@/views/vab/table/index'),
  //       name: 'Table',
  //       meta: {
  //         title: '表格',
  //         permissions: ['admin'],
  //       },
  //     },
  //     {
  //       path: 'map',
  //       component: () => import('@/views/vab/map/index'),
  //       name: 'Map',
  //       meta: {
  //         title: '地图',
  //         permissions: ['admin'],
  //       },
  //     },

  //     {
  //       path: 'webSocket',
  //       name: 'WebSocket',
  //       component: () => import('@/views/vab/webSocket/index'),
  //       meta: { title: 'webSocket', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'form',
  //       name: 'Form',
  //       component: () => import('@/views/vab/form/index'),
  //       meta: { title: '表单', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'element',
  //       name: 'Element',
  //       component: () => import('@/views/vab/element/index'),
  //       meta: { title: '常用组件', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'tree',
  //       name: 'Tree',
  //       component: () => import('@/views/vab/tree/index'),
  //       meta: { title: '树', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'verify',
  //       name: 'Verify',
  //       component: () => import('@/views/vab/verify/index'),
  //       meta: { title: '验证码', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'menu1',
  //       component: () => import('@/views/vab/nested/menu1/index'),
  //       name: 'Menu1',
  //       alwaysShow: true,
  //       meta: {
  //         title: '嵌套路由 1',
  //         permissions: ['admin'],
  //       },
  //       children: [
  //         {
  //           path: 'menu1-1',
  //           name: 'Menu1-1',
  //           alwaysShow: true,
  //           meta: { title: '嵌套路由 1-1' },
  //           component: () => import('@/views/vab/nested/menu1/menu1-1/index'),

  //           children: [
  //             {
  //               path: 'menu1-1-1',
  //               name: 'Menu1-1-1',
  //               meta: { title: '嵌套路由 1-1-1' },
  //               component: () =>
  //                 import('@/views/vab/nested/menu1/menu1-1/menu1-1-1/index'),
  //             },
  //           ],
  //         },
  //       ],
  //     },
  //     {
  //       path: 'magnifier',
  //       name: 'Magnifier',
  //       component: () => import('@/views/vab/magnifier/index'),
  //       meta: { title: '放大镜', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'loading',
  //       name: 'Loading',
  //       component: () => import('@/views/vab/loading/index'),
  //       meta: { title: 'loading', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'player',
  //       name: 'Player',
  //       component: () => import('@/views/vab/player/index'),
  //       meta: { title: '视频播放器', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'markdownEditor',
  //       name: 'MarkdownEditor',
  //       component: () => import('@/views/vab/markdownEditor/index'),
  //       meta: { title: 'markdown编辑器', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'editor',
  //       name: 'Editor',
  //       component: () => import('@/views/vab/editor/index'),
  //       meta: {
  //         title: '富文本编辑器',
  //         permissions: ['admin'],
  //         badge: 'New',
  //       },
  //     },
  //     {
  //       path: 'backToTop',
  //       name: 'BackToTop',
  //       component: () => import('@/views/vab/backToTop/index'),
  //       meta: { title: '返回顶部', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'lodash',
  //       name: 'Lodash',
  //       component: () => import('@/views/vab/lodash/index'),
  //       meta: { title: 'lodash', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'smallComponents',
  //       name: 'SmallComponents',
  //       component: () => import('@/views/vab/smallComponents/index'),
  //       meta: { title: '小组件', permissions: ['admin'] },
  //     },

  //     {
  //       path: 'upload',
  //       name: 'Upload',
  //       component: () => import('@/views/vab/upload/index'),
  //       meta: { title: '上传', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'log',
  //       name: 'Log',
  //       component: () => import('@/views/vab/errorLog/index'),
  //       meta: { title: '错误日志模拟', permissions: ['admin'] },
  //     },
  //     {
  //       path: 'https://github.com/chuzhixin/vue-admin-beautiful?utm_source=gold_browser_extension',
  //       name: 'ExternalLink',
  //       meta: {
  //         title: '外链',
  //         target: '_blank',
  //         permissions: ['admin', 'editor'],
  //         badge: 'New',
  //       },
  //     },
  //     {
  //       path: 'more',
  //       name: 'More',
  //       component: () => import('@/views/vab/more/index'),
  //       meta: { title: '关于', permissions: ['admin'] },
  //     },
  //   ],
  // },
  // {
  //   path: '/mall',
  //   component: Layout,
  //   redirect: 'noRedirect',
  //   name: 'Mall',
  //   meta: {
  //     title: '商000城',
  //     icon: 'shopping-cart',
  //     permissions: ['admin'],
  //   },

  //   children: [
  //     {
  //       path: 'pay',
  //       name: 'Pay',
  //       component: () => import('@/views/mall/pay/index'),
  //       meta: {
  //         title: '支付',
  //         noKeepAlive: true,
  //       },
  //       children: null,
  //     },
  //     {
  //       path: 'goodsList',
  //       name: 'GoodsList',
  //       component: () => import('@/views/mall/goodsList/index'),
  //       meta: {
  //         title: '商品列表',
  //       },
  //     },
  //   ],
  // },

  {
    path: '*',
    redirect: '/404',
    hidden: true,
  },
]

const router = new VueRouter({
  base: publicPath,
  mode: routerMode,
  scrollBehavior: () => ({
    y: 0,
  }),
  routes: constantRoutes,
})

export function resetRouter() {
  location.reload()
}

export default router
