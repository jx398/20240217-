<template>
  <div>
    <div
      style="
        padding: 10px;
        position: absolute;
        top: -6px;
        z-index: 9;
        right: 260px;
      "
    >
      <el-button type="success" @click="saveEvent">保存数据</el-button>
      <el-button type="success" @click="shengchengBaogao">
        4生成评审报告
      </el-button>
      <el-button v-if="baogaoLink" type="success">
        <el-tooltip
          class="item"
          effect="dark"
          content="点击下载"
          placement="bottom"
          style="color: white"
        >
          <el-link type="success" :href="ps_BaogaoLink">
            5下载评审记录
            <i class="el-icon-document"></i>
          </el-link>
        </el-tooltip>
      </el-button>
      <el-button v-if="baogaoLink" type="success" @click="handleAdd()">
        <el-tooltip
          class="item"
          effect="dark"
          content="查看评审记录"
          placement="bottom"
          style="color: white"
        >
          <el-link type="success">
            6查看评审记录
            <i class="el-icon-document"></i>
          </el-link>
        </el-tooltip>
      </el-button>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane>
        <span slot="label">
          <i class="el-icon-date"></i>
          1.概述
        </span>
        <el-tag>
          <el-link type="danger">{{ PS_ID }}</el-link>
          -
          <el-link type="success">{{ ps_DanWei }}</el-link>
        </el-tag>
        <table>
          <tr>
            <td width="120">1.1 评审组</td>
            <td>
              <span>
                1.1按照安标国家矿用产品安全标志中心的委托，评审组（包含
                <el-link type="danger">{{ ps_RenYuan }}</el-link>
                等 2 位评审员）于
                <el-link type="danger">{{ ps_StartTime }}</el-link>
                至
                <el-link type="danger">{{ ps_EndTime }}</el-link>
                （共计
                <el-link type="danger">{{ ps_AllTime }}</el-link>
                日）对
                <el-link type="danger">{{ ps_DanWei }}</el-link>
                实施了矿用产品安全标志工厂评审。
              </span>
            </td>
          </tr>
          <tr>
            <td>1.2评审类型：</td>
            <td>
              <el-checkbox-group
                v-model="PS_Type"
                style="display: inline"
                disabled
              >
                <el-checkbox label="申办评审"></el-checkbox>
                <el-checkbox label="监督评审"></el-checkbox>
              </el-checkbox-group>
            </td>
          </tr>
          <tr>
            <td>1.3评审目的：</td>
            <td>
              <el-checkbox-group
                v-model="PS_Type"
                disabled
                style="display: inline"
              >
                <el-checkbox label="申办评审">
                  评价工厂的生产能力、检验能力、人员能力、产品质量保证能力及产品一致性控制等是否符合安全标志审核发放实施规则的要求。
                </el-checkbox>
                <el-checkbox label="监督评审">
                  评价工厂生产与检验的实施、产品质量管理体系的运行及产品一致性控制等是否持续符合安全标志审核发放实施规则的要求。
                </el-checkbox>
              </el-checkbox-group>
            </td>
          </tr>
          <tr>
            <td>1.4 评审依据：</td>
            <td>
              <biaozhun
                ref="psYiJu"
                :key="key1"
                :proptable-data.sync="prop_PS_YiJu"
              ></biaozhun>
            </td>
          </tr>
          <tr>
            <td>1.5评审项目:</td>
            <td>
              <el-link :href="PS_RenWuShu" target="_blank">
                <i class="el-icon-view el-icon--right"></i>
                详见《安全标志工厂评审任务书》。
              </el-link>
            </td>
          </tr>
          <tr>
            <td>1.6参与人员:</td>
            <td>
              1.6参与评审的人员详见附件“安全标志工厂评审首末次会议人员签到表”。
            </td>
          </tr>
          <tr>
            <td>1.7 工厂概况</td>
            <td>
              <router-link to="/personnelManagement/factoryManagement">
                详见工厂概况页面
              </router-link>
            </td>
          </tr>
        </table>
      </el-tab-pane>
      <el-tab-pane label="2. 工厂评审情况综述">
        <el-tag>
          <el-link type="danger">{{ PS_ID }}</el-link>
          -
          <el-link type="success">{{ ps_DanWei }}</el-link>
        </el-tag>
        <table>
          <tr>
            <td width="150">
              2.1 主体资格
              <el-tag
                v-if="!showEdit1"
                type="success"
                size="mini"
                @click="show('Ref_2_1')"
              >
                编辑
              </el-tag>
              <el-tag
                v-if="showEdit1"
                type="success"
                size="mini"
                @click="save('Ref_2_1')"
              >
                保存
              </el-tag>
              <el-tag
                v-if="showEdit1"
                type="success"
                size="mini"
                @click="cancel('Ref_2_1')"
              >
                取消
              </el-tag>
            </td>
            <td>
              <span v-if="!showEdit1" v-html="ps_2_1"></span>
              <!--eslint-enable-->

              <vab-quill
                v-if="showEdit1"
                ref="Ref_2_1"
                v-model="ps_2_1"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.2 质量管理体系
              <div>
                <el-tag
                  v-if="!showEdit2"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_2')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit2"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_2')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit2"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_2')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit2" v-html="ps_2_2"></span>

              <vab-quill
                v-if="showEdit2"
                ref="Ref_2_2"
                v-model="ps_2_2"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.3 管理职责
              <div>
                <el-tag
                  v-if="!showEdit3"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_3')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit3"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_3')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit3"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_3')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit3" v-html="ps_2_3"></span>

              <vab-quill
                v-if="showEdit3"
                ref="Ref_2_3"
                v-model="ps_2_3"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.4人员能力
              <div>
                <el-tag
                  v-if="!showEdit4"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_4')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit4"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_4')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit4"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_4')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit4" v-html="ps_2_4"></span>

              <vab-quill
                v-if="showEdit4"
                ref="Ref_2_4"
                v-model="ps_2_4"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.5 文件管理和记录
              <div>
                <el-tag
                  v-if="!showEdit5"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_5')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit5"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_5')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit5"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_5')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit5" v-html="ps_2_5"></span>

              <vab-quill
                v-if="showEdit5"
                ref="Ref_2_5"
                v-model="ps_2_5"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.6 采购与外协
              <div>
                <el-tag
                  v-if="!showEdit6"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_6')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit6"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_6')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit6"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_6')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit6" v-html="ps_2_6"></span>

              <vab-quill
                v-if="showEdit6"
                ref="Ref_2_6"
                v-model="ps_2_6"
                :options="options"
              ></vab-quill>
            </td>
          </tr>

          <tr>
            <td width="100">
              2.7 生产控制
              <div>
                <el-tag
                  v-if="!showEdit7"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_7')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit7"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_7')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit7"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_7')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit7" v-html="ps_2_7"></span>

              <vab-quill
                v-if="showEdit7"
                ref="Ref_2_7"
                v-model="ps_2_7"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.8 检验和测试
              <div>
                <el-tag
                  v-if="!showEdit8"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_8')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit8"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_8')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit8"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_8')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit8" v-html="ps_2_8"></span>

              <vab-quill
                v-if="showEdit8"
                ref="Ref_2_8"
                v-model="ps_2_8"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.9 不合格品控制
              <div>
                <el-tag
                  v-if="!showEdit9"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_9')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit9"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_9')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit9"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_9')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit9" v-html="ps_2_9"></span>

              <vab-quill
                v-if="showEdit9"
                ref="Ref_2_9"
                v-model="ps_2_9"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.10 变更及一致性控制
              <div>
                <el-tag
                  v-if="!showEdit10"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_10')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit10"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_10')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit10"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_10')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit10" v-html="ps_2_10"></span>

              <vab-quill
                v-if="showEdit10"
                ref="Ref_2_10"
                v-model="ps_2_10"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.11 库房管理
              <div>
                <el-tag
                  v-if="!showEdit11"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_11')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit11"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_11')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit11"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_11')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit11" v-html="ps_2_11"></span>

              <vab-quill
                v-if="showEdit11"
                ref="Ref_2_11"
                v-model="ps_2_11"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td width="100">
              2.12 安全标志标识
              <div>
                <el-tag
                  v-if="!showEdit12"
                  type="success"
                  size="mini"
                  @click="show('Ref_2_12')"
                >
                  编辑
                </el-tag>
                <el-tag
                  v-if="showEdit12"
                  type="success"
                  size="mini"
                  @click="save('Ref_2_12')"
                >
                  保存
                </el-tag>
                <el-tag
                  v-if="showEdit12"
                  type="success"
                  size="mini"
                  @click="cancel('Ref_2_12')"
                >
                  取消
                </el-tag>
              </div>
            </td>
            <td>
              <span v-if="!showEdit12" v-html="ps_2_12"></span>

              <vab-quill
                v-if="showEdit12"
                ref="Ref_2_12"
                v-model="ps_2_12"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
        </table>
      </el-tab-pane>
      <el-tab-pane label="3. 综合评价">
        <el-tag>
          <el-link type="danger">{{ PS_ID }}</el-link>
          -
          <el-link type="success">{{ ps_DanWei }}</el-link>
        </el-tag>
        <table>
          <tr>
            <td width="100">
              3.1 主体资格
              <el-tag
                v-if="!showEdit13"
                type="success"
                size="mini"
                @click="show('Ref_2_13')"
              >
                编辑
              </el-tag>
              <el-tag
                v-if="showEdit13"
                type="success"
                size="mini"
                @click="save('Ref_2_13')"
              >
                保存
              </el-tag>
              <el-tag
                v-if="showEdit13"
                type="success"
                size="mini"
                @click="cancel('Ref_2_13')"
              >
                取消
              </el-tag>
            </td>
            <td>
              结论综述：
              <span v-if="!showEdit13" v-html="ps_2_13"></span>
              <!--eslint-enable-->

              <vab-quill
                v-if="showEdit13"
                ref="Ref_2_13"
                v-model="ps_2_13"
                :options="options"
              ></vab-quill>
              <el-divider></el-divider>
              评审结论：
              <span v-if="!showEdit13" v-html="ps_2_16"></span>

              <vab-quill
                v-if="showEdit13"
                ref="Ref_2_16"
                v-model="ps_2_16"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
          <tr>
            <td>3.2 不符合项</td>
            <td>
              <router-link to="/personnelManagement/buhegeDetail">
                见不合格项报告页
              </router-link>
              <productTable
                ref="PS_BuHege"
                :key="key0"
                :proptable-data.sync="prop_PS_BuHege"
                :typeData="dataType"
              ></productTable>
              <p>
                整改期限：
                <el-date-picker
                  v-model="PS_ZhengGaiTime"
                  align="right"
                  type="date"
                  placeholder="选择日期"
                  format="yyyy年MM月dd日"
                  value-format="yyyy-MM-dd"
                  :picker-options="pickerOptions"
                ></el-date-picker>
              </p>
            </td>
          </tr>
          <tr>
            <td>3.3 确认产品范围</td>
            <td>
              <p>表3 评审合格产品目录</p>

              <productTable
                ref="hegeMulu"
                :key="key2"
                :proptableData.sync="prop_PS_hegeMulu"
                :typeData="dataType1"
              />
              <p>表4 评审不合格产品目录</p>
              <productTable
                ref="buhegeMulu"
                :key="key3"
                :proptableData.sync="prop_PS_buhegeMulu"
                :typeData="dataType2"
              />
              <p>不合格主要原因</p>
              <el-tag
                v-if="!showEdit14"
                type="success"
                size="mini"
                @click="show('Ref_2_14')"
              >
                编辑
              </el-tag>
              <el-tag
                v-if="showEdit14"
                type="success"
                size="mini"
                @click="save('Ref_2_14')"
              >
                保存
              </el-tag>
              <el-tag
                v-if="showEdit14"
                type="success"
                size="mini"
                @click="cancel('Ref_2_14')"
              >
                取消
              </el-tag>
              <span v-if="!showEdit14" v-html="ps_2_14"></span>

              <vab-quill
                v-if="showEdit14"
                ref="Ref_2_14"
                v-model="ps_2_14"
                :options="options"
              ></vab-quill>
            </td>
          </tr>
        </table>
        <div></div>
      </el-tab-pane>
      <el-tab-pane label="4.其它">
        <el-tag>
          <el-link type="danger">{{ PS_ID }}</el-link>
          -
          <el-link type="success">{{ ps_DanWei }}</el-link>
        </el-tag>
        <p>4.1 前一次评审整改要求的落实情况</p>
        <productTable
          ref="qianciZhenggai"
          :key="key4"
          :proptableData.sync="prop_PS_qianciZhenggai"
          :typeData="dataType3"
        />
        <p>
          4.2 特殊情况说明
          <el-tag
            v-if="!showEdit15"
            type="success"
            size="mini"
            @click="show('Ref_2_15')"
          >
            编辑
          </el-tag>
          <el-tag
            v-if="showEdit15"
            type="success"
            size="mini"
            @click="save('Ref_2_15')"
          >
            保存
          </el-tag>
          <el-tag
            v-if="showEdit15"
            type="success"
            size="mini"
            @click="cancel('Ref_2_15')"
          >
            取消
          </el-tag>
        </p>
        <span v-if="!showEdit15" v-html="ps_2_15"></span>

        <vab-quill
          v-if="showEdit15"
          ref="Ref_2_15"
          v-model="ps_2_15"
          :options="options"
        ></vab-quill>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import vabQuill from '@/plugins/vabQuill'
  import productTable from './components/productTable.vue'
  import biaozhun from './components/biaozhun.vue'
  import axios from 'axios'
  import 'quill/dist/quill.snow.css'
  import VXETable from 'vxe-table'

  const psList = [
    'ps_2_1',
    'ps_2_2',
    'ps_2_3',
    'ps_2_4',
    'ps_2_5',
    'ps_2_6',
    'ps_2_7',
    'ps_2_8',
    'ps_2_9',
    'ps_2_10',
    'ps_2_11',
    'ps_2_12',
    'ps_2_13',
    'ps_2_14',
    'ps_2_15',
    'ps_2_16',
  ]
  import { diffSubtract } from '@/utils'
  export default {
    name: 'App',
    components: {
      vabQuill,
      productTable,
      biaozhun,
    },
    data() {
      return {
        dataType: 'buhege',
        dataType1: 'hegeProduct',
        dataType2: 'buhegeProduct',
        dataType3: 'qianciZhenggai',
        PS_BuHege: '',
        PS_JieLunDetail: '',
        pickerOptions: {
          disabledDate(time) {
            return time.getTime() < Date.now()
          },
          shortcuts: [
            {
              text: '一个月',
              onClick(picker) {
                const date = new Date()
                const year = date.getFullYear()
                const month = date.getMonth()
                const day = date.getDate()
                const newMonth = month + 1
                let newYear = year
                if (newMonth > 11) {
                  newYear++
                  newMonth = 1
                }
                const newDate = new Date(newYear, newMonth, day)
                date.setTime(newDate)
                picker.$emit('pick', date)
              },
            },
            {
              text: '两个月',
              onClick(picker) {
                const date = new Date()
                const year = date.getFullYear()
                const month = date.getMonth()
                const day = date.getDate()
                const newMonth = month + 2
                let newYear = year
                if (newMonth > 11) {
                  newYear++
                  newMonth = 1
                }
                const newDate = new Date(newYear, newMonth, day)
                date.setTime(newDate)
                picker.$emit('pick', date)
              },
            },
            {
              text: '45天',
              onClick(picker) {
                const date = new Date()
                const timestamp = date.getTime()
                const millisecondsToAdd = 45 * 24 * 60 * 60 * 1000
                const newTimestamp = timestamp + millisecondsToAdd
                date.setTime(newTimestamp)
                picker.$emit('pick', date)
              },
            },
          ],
        },
        key0: Date.now(),
        key1: Date.now() - 1000,
        key2: Date.now() - 2000,
        key3: Date.now() - 3000,
        key4: Date.now() - 4000,
        prop_PS_qianciZhenggai: [],
        prop_PS_buhegeMulu: [],
        prop_PS_hegeMulu: [],
        prop_PS_YiJu: [],
        prop_PS_BuHege: [],
        PS_ID: '',
        baogaoLink: false,
        ps_BaogaoLink: '',
        edit2_1: true,
        PS_Target: '',
        PS_RenWuShu: '',
        ps_2_1: '',
        ps_2_2: '',
        ps_2_3: '',
        ps_2_4: '',
        ps_2_5: '',
        ps_2_6: '',
        ps_2_7: '',
        ps_2_8: '',
        ps_2_9: '',
        ps_2_10: '',
        ps_2_11: '',
        ps_2_12: '',
        ps_2_13: '',
        ps_2_14: '',
        ps_2_15: '',
        ps_2_16: '',
        showEdit1: false,
        showEdit2: false,
        showEdit3: false,
        showEdit4: false,
        showEdit5: false,
        showEdit6: false,
        showEdit7: false,
        showEdit8: false,
        showEdit9: false,
        showEdit10: false,
        showEdit11: false,
        showEdit12: false,
        showEdit13: false,
        showEdit14: false,
        showEdit15: false,
        ps_3_1: '',
        ps_4_1: '',
        PS_YiJu: '',
        showEdit_4: false,
        showEdit: true,
        ps_RenYuan: '',
        ps_StartTime: '',
        ps_EndTime: '',
        ps_AllTime: '',
        ps_DanWei: '',
        PS_Type: '',
        ps_MuBiao1: '',
        ps_MuBiao2: '',
        PS_ZhengGaiTime: '',

        radio: 3,
        options: {
          theme: 'snow',
          bounds: document.body,
          debug: 'warn',
          modules: {
            toolbar: [
              ['bold', 'italic', 'underline', 'strike'],
              // [{ header: [1, 2, 3, 4, 5, 6, false] }],
              // [{ size: ['small', false, 'large', 'huge'] }],
              [{ color: [] }, { background: [] }],
              //['blockquote', 'code-block'],
              [{ list: 'ordered' }, { list: 'bullet' }],
              [{ script: 'sub' }, { script: 'super' }],
              [{ indent: '-1' }, { indent: '+1' }],
              [{ align: [] }],
              [{ direction: 'rtl' }],
              //[{ font: ['仿宋', '楷体'] }],
              ['clean'],
              //['link', 'image'],
            ],
          },
          placeholder: '内容...',
          readOnly: false,
        },
        content: '',
      }
    },
    watch: {
      // 监听name属性
      prop_PS_YiJu: function (newVal, oldVal) {
        // 执行回调函数
        this.prop_PS_YiJu = newVal
      },
      immediate: true,
      deep: true, //为true，表示深度监听，这时候就能监测到a值变化
    },
    mounted() {
      console.log('mounted')
      console.log(this.$store.detail)
    },
    created() {
      if (this.$store.state.detail.PS_ID == '') {
        this.$alert('请选择或新建评审任务', '提示', {
          confirmButtonText: '确定',
          callback: (action) => {
            //如果没有选择评审任务就返回到首页
            console.log(this.$route.path)
            //console.log(this.delTabsBar(this.$route.path))
            this.$router.push('/')
          },
        })
      }
      //this.fetchData()
      this.$nextTick(() => {
        this.fetchData()
        //this.checkNodes = this.$refs.demoTree.getCheckedNodes()
      })
    },
    methods: {
      getData() {
        console.log('_yiju')
        console.log(_yiju)
        console.log(_hegeMulu)
        console.log(_buhegeMulu)
        console.log(_qianciZhenggai)
        psList.map((item) => {
          console.log(this[item])
        })
      },
      async fetchData() {
        this.PS_ID = this.$store.state.detail.PS_ID
        this.ps_RenYuan = this.$store.state.detail.PS_RenYuan
        this.ps_StartTime = this.$store.state.detail.PS_RiQiStart
        this.ps_EndTime = this.$store.state.detail.PS_RiQiEnd
        this.ps_AllTime = diffSubtract(this.ps_StartTime, this.ps_EndTime) + ''
        this.ps_DanWei = this.$store.state.detail.PS_DanWei
        this.PS_Type = this.$store.state.detail.PS_Type.split(',')
        this.PS_RenWuShu = this.$store.state.detail.PS_RenWuShu
        const _that = this
        this.PS_ID = this.$store.state.detail.PS_ID
        // Send a POST request
        let { count, Data, PS_BaoGaoLink, PS_JieLunDetail, PS_BuHege } =
          await axios({
            method: 'post',
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getBaoGao', //请求地址
            data: JSON.stringify({ id: this.PS_ID }), //表单序列化
          }).then((response) => {
            // Handle response
            console.log('response.data')
            console.log(response.data)
            console.log('response.data')
            return response.data
          })
        console.log(count, Data)
        this.prop_PS_YiJu = Array.from(Data.PS_BaoGao.PS_YiJu)
        let _tempArray = Array.from(PS_BuHege)
        let _propArray = new Array()
        _tempArray.forEach((item) => {
          let _obj = {}
          _obj.ZG_BiaoTi = item.value
          _obj.ZG_YaoQiu = item.BHG_Type
          _obj.ZG_LuoShi = item.BHG_ShiShi
          _obj.ZG_BeiZhu = item.BHG_ZhengGai
          _propArray.push(_obj)
        })
        this.prop_PS_BuHege = _propArray
        console.log('this.prop_PS_YiJu')
        console.log(Data.PS_BaoGao.PS_YiJu)
        console.log(this.prop_PS_YiJu)
        console.log('_propArray')
        console.log(_propArray)

        console.log(Array.from(this.prop_PS_YiJu))
        this.prop_PS_YiJu = Array.from(this.prop_PS_YiJu)
        console.log(this.prop_PS_YiJu)

        this.prop_PS_hegeMulu =
          Data.PS_BaoGao.PS_hegeMulu == null
            ? []
            : Data.PS_BaoGao.PS_hegeMulu == ''
            ? []
            : Data.PS_BaoGao.PS_hegeMulu
        this.prop_PS_buhegeMulu =
          Data.PS_BaoGao.PS_buhegeMulu == null
            ? []
            : Data.PS_BaoGao.PS_buhegeMulu == ''
            ? []
            : Data.PS_BaoGao.PS_buhegeMulu
        this.prop_PS_qianciZhenggai =
          Data.PS_BaoGao.PS_qianciZhenggai == null
            ? []
            : Data.PS_BaoGao.PS_qianciZhenggai == ''
            ? []
            : Data.PS_BaoGao.PS_qianciZhenggai
        this.ps_2_1 = Data.PS_BaoGao.ps_2_1 ? Data.PS_BaoGao.ps_2_1 : ''
        this.ps_2_2 = Data.PS_BaoGao.ps_2_2 ? Data.PS_BaoGao.ps_2_2 : ''
        this.ps_2_3 = Data.PS_BaoGao.ps_2_3 ? Data.PS_BaoGao.ps_2_3 : ''
        this.ps_2_4 = Data.PS_BaoGao.ps_2_4 ? Data.PS_BaoGao.ps_2_4 : ''
        this.ps_2_5 = Data.PS_BaoGao.ps_2_5 ? Data.PS_BaoGao.ps_2_5 : ''
        this.ps_2_6 = Data.PS_BaoGao.ps_2_6 ? Data.PS_BaoGao.ps_2_6 : ''
        this.ps_2_7 = Data.PS_BaoGao.ps_2_7 ? Data.PS_BaoGao.ps_2_7 : ''
        this.ps_2_8 = Data.PS_BaoGao.ps_2_8 ? Data.PS_BaoGao.ps_2_8 : ''
        this.ps_2_9 = Data.PS_BaoGao.ps_2_9 ? Data.PS_BaoGao.ps_2_9 : ''
        this.ps_2_10 = Data.PS_BaoGao.ps_2_10 ? Data.PS_BaoGao.ps_2_10 : ''
        this.ps_2_11 = Data.PS_BaoGao.ps_2_11 ? Data.PS_BaoGao.ps_2_11 : ''
        this.ps_2_12 = Data.PS_BaoGao.ps_2_12 ? Data.PS_BaoGao.ps_2_12 : ''
        this.ps_2_13 = Data.PS_BaoGao.ps_2_13 ? Data.PS_BaoGao.ps_2_13 : ''
        this.ps_2_14 = Data.PS_BaoGao.ps_2_14 ? Data.PS_BaoGao.ps_2_14 : ''
        this.ps_2_15 = Data.PS_BaoGao.ps_2_15 ? Data.PS_BaoGao.ps_2_15 : ''
        this.ps_2_16 = Data.PS_BaoGao.ps_2_16 ? Data.PS_BaoGao.ps_2_16 : ''
        this.PS_ZhengGaiTime = Data.PS_BaoGao.PS_ZhengGaiTime
          ? Data.PS_BaoGao.PS_ZhengGaiTime
          : ''
        this.ps_BaoGaoLink = PS_BaoGaoLink ? PS_BaoGaoLink : ''
        this.baogaoLink = this.ps_BaoGaoLink == '' ? false : true
        setTimeout(() => {
          _that.listLoading = false
          this.key0 = Date.now()
          this.key1 = Date.now() - 10000
          this.key2 = Date.now() - 20000
          this.key3 = Date.now() - 30000
          this.key4 = Date.now() - 40000

          console.log(this.key0)
          console.log(this.key1)
          console.log(this.key2)
          console.log(this.key3)
          console.log(this.key4)
        }, 300)
      },
      async saveEvent() {
        const type = await VXETable.modal.confirm('您确定要保存修改吗?')
        if (type === 'confirm') {
          //const { data, totalCount } = this.queryForm
          // Send a POST request
          let obj = {}
          let _yiju = this.$refs.psYiJu.popData()
          let _PS_BuHege = this.$refs.PS_BuHege.popData()
          console.log('_PS_BuHege')
          console.log(_PS_BuHege)
          console.log(_yiju)
          console.log(JSON.stringify(_yiju))
          let _hegeMulu = this.$refs.hegeMulu.popData()
          let _buhegeMulu = this.$refs.buhegeMulu.popData()
          let _qianciZhenggai = this.$refs.qianciZhenggai.popData()
          obj.ps_AllTime = this.ps_AllTime
          obj.PS_YiJu = _yiju
          obj.PS_hegeMulu = _hegeMulu
          obj.PS_buhegeMulu = _buhegeMulu
          obj.PS_qianciZhenggai = _qianciZhenggai
          obj.ps_2_1 = this.ps_2_1
          obj.ps_2_2 = this.ps_2_2
          obj.ps_2_3 = this.ps_2_3
          obj.ps_2_4 = this.ps_2_4
          obj.ps_2_5 = this.ps_2_5
          obj.ps_2_6 = this.ps_2_6
          obj.ps_2_7 = this.ps_2_7
          obj.ps_2_8 = this.ps_2_8
          obj.ps_2_9 = this.ps_2_9
          obj.ps_2_10 = this.ps_2_10
          obj.ps_2_11 = this.ps_2_11
          obj.ps_2_12 = this.ps_2_12
          obj.ps_2_13 = this.ps_2_13
          obj.ps_2_14 = this.ps_2_14
          obj.ps_2_15 = this.ps_2_15
          obj.ps_2_16 = this.ps_2_16
          obj.PS_ZhengGaiTime = this.PS_ZhengGaiTime
          let _baogaoLink = this.ps_BaoGaoLink ? '' : this.ps_BaoGaoLink
          let _tempA = new Array()
          let _tempB = Array.from(_PS_BuHege)
          _tempB.forEach((item) => {
            let _o = {}
            _o.BHG_ID = ''
            _o.id = ''
            _o.value = item.BHG_ID
            _o.BHG_Type = item.BHG_Type
            _o.BHG_ShiShi = item.BHG_ShiShi
            _o.BHG_ZhengGai = item.BHG_ZhengGai
            _o.isEdit = false
            _o.isAdd = false
            _tempA.push(_o)
          })

          let { count, Data } = await axios({
            method: 'post',
            contentType: 'application/json;charset=UTF-8', //contentType 默认值：“application/x-www-form-urlencoded; charset=UTF-8”
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateBaoGao', //请求地址
            data: JSON.stringify({
              PS_ID: this.PS_ID,
              PS_BaoGao: obj,
              PS_BaoGaoLink: _baogaoLink,
              PS_BuHege: _tempA,
            }), //表单序列化
          }).then((response) => {
            // Handle response
            console.log('response.data')
            console.log(response.data)
            console.log('response.data')
            return response.data
          })
          VXETable.modal.message({
            content: `保存成功`,
            status: 'success',
          })
        }
      },
      escape2Html(str) {
        var arrEntities = { lt: '<', gt: '>', nbsp: ' ', amp: '&', quot: '"' }
        return str.replace(/&(lt|gt|nbsp|amp|quot);/gi, function (all, t) {
          return arrEntities[t]
        })
      },
      async shengchengBaogao() {
        const loading = this.$loading({
          lock: true,
          text: '拼命生成评审报告中。。。。。',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.8)',
        })
        let Data = await axios({
          method: 'post',
          contentType: 'application/json;charset=UTF-8', //contentType 默认值：“application/x-www-form-urlencoded; charset=UTF-8”

          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=shengchengPSBaoGao', //请求地址
          data: JSON.stringify({
            PS_ID: this.PS_ID,
          }), //表单序列化
        }).then((response) => {
          // Handle response
          console.log('response.data')
          console.log(response.data)
          console.log('response.data')
          return response.data
        })
        setTimeout(() => {
          this.$message({
            type: 'success',
            message: '生成成功!点击下载报告下载！',
          })
          this.baogaoLink = true
          this.ps_BaoGaoLink = Data
          setTimeout(() => loading.close(), 1000)
          //this.pdf_src = that.buhegeBaoGaoFile.replace('doc', 'pdf')
          //window.location.href = this.buhegeBaoGaoFile
        }, 600)
      },
      cancel(target) {
        let _newRef = target.replace('Ref', 'ps')

        const matches = /Ref_2_(\d+)/.exec(target)
        if (!matches) {
          return null
        }
        let _num = matches[1]
        this[`showEdit${_num}`] = false
        this.$message({
          message: '取消编辑' + target,
          type: 'warning',
        })
        console.log(this.$refs[target])
        this.$refs[target].currentVaule = '123123'
        console.log(this.$refs[target].currentValue)
      },
      show(target) {
        const matches = /Ref_2_(\d+)/.exec(target)
        if (!matches) {
          return null
        }
        let _num = matches[1]
        this[`showEdit${_num}`] = true
      },
      save(target) {
        let _newRef = target.replace('Ref', 'ps')
        const matches = /Ref_2_(\d+)/.exec(target)
        if (!matches) {
          return null
        }
        let _num = matches[1]
        console.log(this.$refs[target])
        console.log(this.$refs[target].currentValue)
        this[`showEdit${_num}`] = false
        this[_newRef] = this.$refs[target].currentValue
        console.log(this[_newRef])
      },
      fetchStore() {
        this.listLoading = true
        const _that = this
        console.log('fetchStore->this.$store.state.detail')
        console.log(this.$store.state.detail)
        console.log(this.PS_ID)

        console.log(this.$store.state.detail.PS_RenYuan)
        console.log(this.ps_AllTime)
        console.log(this.ps_RenYuan)
        if (this.PS_ID != '') {
        } else {
          _that.$alert('请选择或新建评审任务', '提示', {
            confirmButtonText: '确定',
            callback: (action) => {
              //_that.$baseMessage('请选择或新建评审任务', 'error')
            },
          })
        }
        setTimeout(() => {
          _that.listLoading = false
        }, 300)
      },
    },
  }
</script>
<style scoped>
  table {
    width: 100%;
    border-collapse: collapse;
  }
  table caption {
    font-size: 2em;
    font-weight: bold;
    margin: 1em 0;
  }
  th,
  td {
    border: 1px solid #e5e4e4;
    text-align: left;
    padding: 10px;
    line-height: 24px;
  }
  table thead tr {
    background-color: #008c8c;
    color: #fff;
  }
  tr:nth-child(odd) {
    background: rgb(255, 255, 255);
  }

  tr:nth-child(even) {
    background: #f8f8f8;
  }
  tr:hover {
    background-color: #ffffff;
  }
  table tbody tr td:first-child {
    color: #f40;
  }
  .vxe-header--column {
    padding: 10px !important;
  }
</style>
