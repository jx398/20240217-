<template>
  <div class="tree-container">
    <el-row :gutter="20">
      <el-col id="xm1" :xs="24" :sm="24" :md="24" :lg="19" :xl="19">
        <el-row>
          <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
            <el-alert type="info" size="mini" style="width: 100%">
              <span>
                <el-link type="danger">{{ PS_ID }}</el-link>
                -
                <el-link type="success">{{ PS_DanWei }}</el-link>
                -
                <el-link type="success">{{ pandingObj.xm_jielun }}</el-link>
              </span>
            </el-alert>
            <div v-if="showSelec" ref="showSelectedItems" style="width: 100%">
              <div class="cssShow">
                <span
                  v-for="item in checkNodes"
                  :key="item.id"
                  :value="item.name"
                  label="item.title"
                >
                  <el-tag
                    :class="
                      item.rank == 1
                        ? 'bigFont cssShowSelectedOne'
                        : 'cssShowSelectedOne'
                    "
                    :type="
                      item.rank == 1
                        ? 'danger'
                        : item.rank == 2
                        ? 'success'
                        : 'info'
                    "
                  >
                    <span
                      @click="handleLeft(item.id, item.name)"
                      v-html="
                        [
                          '13.3',
                          '2.1',
                          '8.1.1',
                          '8.1.2',
                          '9.7.1',
                          '11.2',
                          '2.2',
                        ].indexOf(item.value) == -1
                          ? item.value
                          : `★${item.value}`
                      "
                    ></span>
                  </el-tag>
                </span>
              </div>
            </div>
            <el-alert
              v-if="showpanding"
              :type="jielun"
              show-icon
              @close="alertClose"
            >
              <div style="float: left">
                <el-tag><span v-html="PS_JieLunDetail"></span></el-tag>
                <vxe-table
                  :data="tableData"
                  border
                  :column-config="{ resizable: true }"
                  :row-config="{ height: 25 }"
                >
                  <vxe-column field="type" title="类型" width="70"></vxe-column>
                  <vxe-column field="fuhe" title="符合" width="70"></vxe-column>
                  <vxe-column field="bufuhe" title="不符" width="60">
                    <template #default="{ row }">
                      <span
                        :style="
                          row.bufuhe - 0 > 0
                            ? 'padding:10px;background-color:red;color:yellow;font-weight:bold;'
                            : ''
                        "
                      >
                        {{ row.bufuhe }}
                      </span>
                    </template>
                  </vxe-column>
                  <vxe-column field="jibenfuhe" title="基本" width="60">
                    <template #default="{ row }">
                      <span
                        :style="
                          row.jibenfuhe - 0 > 0
                            ? 'padding:10px;background-color:yellow;color:red;font-weight:bold;'
                            : ''
                        "
                      >
                        {{ row.jibenfuhe }}
                      </span>
                    </template>
                  </vxe-column>
                  <vxe-column
                    field="bushiyong"
                    title="不适"
                    width="60"
                  ></vxe-column>
                  <vxe-column
                    field="count"
                    title="合计"
                    width="60"
                  ></vxe-column>
                  <vxe-column field="buhegeXian" title="不合格项" width="420">
                    <template #default="{ row }">
                      <span
                        v-for="item in row.buhegeXian"
                        :key="item.value"
                        :value="item.name"
                        label="item.name"
                      >
                        <el-tag type="danger" class="bhgStyle" size="mini">
                          <span
                            style="cursor: pointer"
                            class="cssShowSelectedOne"
                            @click="handleLeft(item.id, item.name)"
                          >
                            <span
                              v-html="
                                [
                                  '13.3',
                                  '2.1',
                                  '8.1.1',
                                  '8.1.2',
                                  '9.7.1',
                                  '11.2',
                                  '2.2',
                                ].indexOf(item.value) == -1
                                  ? `
                      <span style='color:red'>${item.value}</span>
                      `
                                  : item.value
                              "
                            ></span>
                          </span>
                        </el-tag>
                      </span>
                    </template>
                  </vxe-column>
                </vxe-table>
              </div>
            </el-alert>

            <div
              id="tipsBar"
              ref="showSelectedItems"
              :class="tipsBarFixed == true ? 'tipsFixed' : ''"
            >
              <span style="margin-top: -10px">
                <el-button type="info" @click="changeAllShow">
                  {{ defaultExpanDetail ? '折叠项目' : '打开项目' }}
                </el-button>
                <el-button type="warning" @click="showSelected">
                  {{ showSelec ? '显示选中' : '隐藏选中' }}
                </el-button>

                <el-button type="success" @click="showSelected">
                  1数据分析
                </el-button>
                <el-button type="success" @click="showPanding">
                  2综合判定
                </el-button>
                <el-button type="danger" @click="baogao">
                  3保存评审记录
                </el-button>
                <el-button type="success" @click="bufuheBaogao">
                  4生成不符合报告
                </el-button>
                <el-button v-if="baogaoLink" type="success">
                  <el-tooltip
                    class="item"
                    effect="dark"
                    content="点击下载"
                    placement="bottom"
                    style="color: white"
                  >
                    <el-link type="success" :href="buhegeBaoGaoFile">
                      5下载评审记录
                      <i class="el-icon-document"></i>
                    </el-link>
                  </el-tooltip>
                </el-button>
                <el-button
                  v-if="baogaoLink"
                  type="success"
                  @click="handleAdd()"
                >
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

                <el-button type="danger" @click="XianSibufuhe">
                  {{ !ShowBHG ? '不符合' : '显全部' }}
                </el-button>

                <el-button type="danger" @click="saveData">保存数据</el-button>
                <el-button type="danger" @click="reload">重新载入</el-button>
              </span>
            </div>
          </el-col>
        </el-row>

        <el-tabs
          v-model="selectedItem"
          type="border-card"
          @tab-click="handleClick"
        >
          <el-tab-pane v-if="id1" name="tab2" label="2主体资格">
            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <!--第二项主体资格-->
                <el-card v-show="id1" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm1')">
                    <div class="leftSum id1">
                      <vab-icon
                        :icon="['fas', 'video']"
                        style="color: ffc069"
                      ></vab-icon>
                      2主体资格
                    </div>

                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_2JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      <div>
                        共
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm2Count }}
                        </el-tag>
                        项,其中,否决项
                        <el-tag
                          type="danger"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm2Foujue }}
                        </el-tag>
                        ,考核项
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm2Count - xm2Foujue }}
                        </el-tag>
                        项。
                      </div>
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm2hege == '0' ? 'info' : 'success'">
                          {{ xm2hege }}合格
                        </el-tag>

                        <el-tag v-if="hide_panding" type="warning">
                          {{ xm2jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm2buhege == '0' ? 'info' : 'danger'">
                          {{ xm2buhege }}不合格
                        </el-tag>

                        <el-tag
                          v-if="hide_panding"
                          :type="xm2bushiyong == '0' ? 'info' : 'danger'"
                        >
                          {{ xm2bushiyong }}不适用
                        </el-tag>

                        <el-tag :type="xm2weipan == '0' ? 'info' : 'danger'">
                          {{ xm2weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm1" class="xiangmu">
                    <div v-if="id2" ref="id2" class="id2">
                      <el-tag
                        v-if="id2"
                        type="danger"
                        @click="changeShow('xm2')"
                      >
                        <div class="leftSum">
                          <i class="el-icon-warning"></i>

                          2.1生产合法性
                        </div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm2_1Panding"
                            @change="setMealSelect($event, 'xm2_1P', 'id2')"
                          >
                            <el-checkbox-button
                              v-for="option in twoOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>

                      <div v-if="id2" id="xm2" ref="xm2" class="xiangmu">
                        <div class="neirong">
                          <p>
                            <span class="fouju">★营业执照是否在有效期内？</span>
                            <span class="xm2_1Panding_1">
                              <el-radio-group v-model="xm2_1Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            所生产产品是否在其营业执照的经营范围内？
                            <span class="xm2_1Panding_2">
                              <el-radio-group v-model="xm2_1Panding_2">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            工厂是否取得民用爆破器材产品的相应资质？
                            <span class="xm2_1Panding_3">
                              <el-radio-group v-model="xm2_1Panding_3">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="不适用">/不适用</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm2_1Panding_4"
                              class="xm2_1Panding_4"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                          <p style="color: #aaa">
                            营业执照、相应资质照片应拍照取证,保存在文件夹“主体资格”。
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id3" ref="id3" class="id3">
                      <el-tag
                        v-if="id3"
                        id="xm3"
                        type="danger"
                        @click="changeShow('xm3')"
                      >
                        <div class="leftSum">
                          <i class="el-icon-warning"></i>
                          2.2生产场所
                        </div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm2_2Panding"
                            @change="setMealSelect($event, 'xm2_2P', 'id3')"
                          >
                            <el-checkbox-button
                              v-for="option in twoOptions"
                              :key="option"
                              :label="option"
                              :class="
                                xm2_2Panding[0] == option &&
                                xm2_2Panding[0] == '不符合'
                                  ? 'red'
                                  : ''
                              "
                            >
                              <span
                                :class="
                                  xm2_2Panding[0] == option &&
                                  xm2_2Panding[0] == '不符合'
                                    ? 'ccred'
                                    : ''
                                "
                              >
                                {{ option }}
                              </span>
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div v-if="id3" ref="xm3" class="xiangmu">
                        <div class="neirong">
                          <p>
                            <span class="fouju">
                              ★是否有生产产品所需的固定场所？
                            </span>
                            <span class="xm2_2Panding_1">
                              <el-radio-group v-model="xm2_2Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            生产场所是否有变更？
                            <span class="xm2_2Panding_2">
                              <el-radio-group v-model="xm2_2Panding_2">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            注册地址：
                            <el-input
                              v-model="xm2_2Panding_3"
                              class="xm2_2Panding_3"
                              clearable
                              placeholder="请输入内容"
                              style="width: 80%"
                            ></el-input>
                          </p>
                          <p>
                            生产地址：
                            <el-input
                              v-model="xm2_2Panding_4"
                              class="xm2_2Panding_4"
                              clearable
                              placeholder="请输入内容"
                              style="width: 80%"
                            ></el-input>
                          </p>
                          <p>
                            土地使用类别：
                            <span class="xm2_2Panding_5">
                              <el-radio-group v-model="xm2_2Panding_5">
                                <el-radio label="01">自有</el-radio>
                                <el-radio label="02">租赁</el-radio>
                                <el-radio label="03">划拨</el-radio>
                                <el-radio label="04">无偿使用</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm2_2Panding_6"
                              class="xm2_2Panding_6"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不符合事实"
                              clearable
                            ></el-input>
                          </p>
                          <p style="color: #aaa">
                            企业大门、门牌号、整体外貌、生产场地使用证明需拍照取证,保存在文件夹“主体资格”。
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id4" name="tab3" label="3QMS">
            <el-row id="xm4">
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <!--第三项质量管理体系-->
                <el-card v-show="id4" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm4')">
                    <div class="leftSum id4">
                      <vab-icon
                        :icon="['fas', 'democrat']"
                        style="color: #ff85c0"
                      ></vab-icon>
                      3质量管理体系
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_3JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      <div>
                        共
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm3Count }}
                        </el-tag>
                        项,其中,否决项
                        <el-tag
                          type="danger"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm3Foujue }}
                        </el-tag>
                        ,考核项
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm3Count - xm3Foujue }}
                        </el-tag>
                        项。
                      </div>
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm3hege == '0' ? 'info' : 'success'">
                          {{ xm3hege }}合格
                        </el-tag>

                        <el-tag :type="xm3jibenhege == '0' ? 'info' : 'danger'">
                          {{ xm3jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm3buhege == '0' ? 'info' : 'danger'">
                          {{ xm3buhege }}不合格
                        </el-tag>

                        <el-tag
                          v-if="hide_panding"
                          :type="xm3bushiyong == '0' ? 'info' : 'danger'"
                        >
                          {{ xm3bushiyong }}不适用
                        </el-tag>

                        <el-tag :type="xm3weipan == '0' ? 'info' : 'danger'">
                          {{ xm3weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm4" class="xiangmu">
                    <div ref="id5" class="id5">
                      <el-tag
                        v-if="id5"
                        id="xm6"
                        type="danger"
                        @click="changeShow('xm5')"
                      >
                        <div class="leftSum id5">3.1管理体系</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm3_1Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm3_1Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm3_1Count - xm3_1Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm3_1hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm3_1jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm3_1buhege }}不合格
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm3_1bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm3_1weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>
                      <div v-if="id5" id="xm5" ref="xm5" class="xiangmu">
                        <div v-if="id6" ref="id6" class="id6">
                          <el-tag type="success" @click="changeShow('xm6')">
                            <div class="leftSum id6">3.1.1QMS机构</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm3_1_1Panding"
                                @change="
                                  setMealSelect($event, 'xm3_1_1P', 'id6')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>

                          <div ref="xm6" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否具有质量管理机构？
                                <span class="xm3_1_1Panding_1">
                                  <el-radio-group v-model="xm3_1_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                是否建立完整的质量管理体系？
                                <span class="xm3_1_1Panding_2">
                                  <el-radio-group v-model="xm3_1_1Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>

                              <p>
                                不符合事实：
                                <el-input
                                  v-model="xm3_1_1Panding_3"
                                  class="xm3_1_1Panding_3"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id7" ref="id7" class="id7">
                          <el-tag
                            id="xm7"
                            type="success"
                            @click="changeShow('xm7')"
                          >
                            <div class="leftSum">3.1.2质量管理体系文件</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm3_1_2Panding"
                                @change="
                                  setMealSelect($event, 'xm3_1_2P', 'id7')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div id="xm7" ref="xm7" class="xiangmu">
                            <div class="neirong">
                              <p>
                                质量管理体系文件是否规范？
                                <span class="xm3_1_2Panding_1">
                                  <el-radio-group v-model="xm3_1_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                是否具有可操作性？
                                <span class="xm3_1_2Panding_2">
                                  <el-radio-group v-model="xm3_1_2Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                实际操作是否与文件相符？
                                <span class="xm3_1_2Panding_3">
                                  <el-radio-group v-model="xm3_1_2Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm3_1_2Panding_4"
                                  class="xm3_1_2Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>

                      <div v-if="id8" ref="id8" class="id8">
                        <el-tag
                          v-if="id8"
                          type="danger"
                          @click="changeShow('xm8')"
                        >
                          <div class="leftSum">3.2内部审核与管理评审</div>
                          <div class="secondDanxiang">
                            <div class="tipCount">
                              <el-tag
                                type="danger"
                                style="margin-left: 0px; margin-right: 0px"
                              >
                                {{ xm3_2Count }}
                              </el-tag>

                              <el-tag
                                type="success"
                                style="margin-left: 0px; margin-right: 0px"
                              >
                                {{ xm3_2Foujue }}
                              </el-tag>

                              <el-tag
                                type="warning"
                                style="margin-left: 0px; margin-right: 0px"
                              >
                                {{ xm3_2Count - xm3_2Foujue }}
                              </el-tag>
                            </div>
                            <div class="tipPanding">
                              <el-tag
                                type="danger"
                                style="margin-left: 0px; margin-right: 0px"
                              >
                                {{ xm3_2hege }}合格
                              </el-tag>

                              <el-tag
                                type="success"
                                style="margin-left: 0px; margin-right: 0px"
                              >
                                {{ xm3_2jibenhege }}基本
                              </el-tag>

                              <el-tag
                                type="warning"
                                style="margin-left: 0px; margin-right: 0px"
                              >
                                {{ xm3_2buhege }}不合格
                              </el-tag>

                              <el-tag v-if="hide_panding" type="danger">
                                {{ xm3_2bushiyong }}不适用
                              </el-tag>

                              <el-tag type="danger">
                                {{ xm3_2weipan }}未判定
                              </el-tag>
                            </div>
                          </div>
                        </el-tag>

                        <div v-if="id8" ref="xm8" class="xiangmu">
                          <div v-if="id9" ref="id9" class="id9">
                            <el-tag type="success" @click="changeShow('xm9')">
                              <div class="leftSum">3.2.1内部审核制度</div>
                              <div class="danxiang">
                                <el-checkbox-group
                                  v-model="xm3_2_1Panding"
                                  @change="
                                    setMealSelect($event, 'xm3_2_1P', 'id9')
                                  "
                                >
                                  <el-checkbox-button
                                    v-for="option in threeOptions"
                                    :key="option"
                                    :label="option"
                                  >
                                    {{ option }}
                                  </el-checkbox-button>
                                </el-checkbox-group>
                              </div>
                            </el-tag>
                            <div ref="xm9" class="xiangmu">
                              <div class="neirong">
                                <p>
                                  是否有内部审核制度？
                                  <span class="xm3_2_1Panding_1">
                                    <el-radio-group v-model="xm3_2_1Panding_1">
                                      <el-radio label="是">是</el-radio>
                                      <el-radio label="否">否</el-radio>
                                      <el-radio label="欠">有欠缺</el-radio>
                                    </el-radio-group>
                                  </span>
                                </p>
                                <p>
                                  是否有管理评审制度？
                                  <span class="xm3_2_1Panding_2">
                                    <el-radio-group v-model="xm3_2_1Panding_2">
                                      <el-radio label="是">是</el-radio>
                                      <el-radio label="否">否</el-radio>
                                      <el-radio label="欠">有欠缺</el-radio>
                                    </el-radio-group>
                                  </span>
                                </p>
                                <p>
                                  内部审核制度名称：
                                  <el-input
                                    v-model="xm3_2_1Panding_3"
                                    class="xm3_2_1Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                  编号：
                                  <el-input
                                    v-model="xm3_2_1Panding_4"
                                    class="xm3_2_1Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  管理审核制度名称：
                                  <el-input
                                    v-model="xm3_2_1Panding_5"
                                    class="xm3_2_1Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                  编号：
                                  <el-input
                                    v-model="xm3_2_1Panding_6"
                                    class="xm3_2_1Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  是否至少每年进行一次内部审核？
                                  <span class="xm3_2_1Panding_7">
                                    <el-radio-group v-model="xm3_2_1Panding_7">
                                      <el-radio label="是">是</el-radio>
                                      <el-radio label="否">否</el-radio>
                                      <el-radio label="欠">有欠缺</el-radio>
                                    </el-radio-group>
                                  </span>
                                </p>
                                <p>
                                  是否至少每年进行一次管理评审？
                                  <span class="xm3_2_1Panding_8">
                                    <el-radio-group v-model="xm3_2_1Panding_8">
                                      <el-radio label="是">是</el-radio>
                                      <el-radio label="否">否</el-radio>
                                      <el-radio label="欠">有欠缺</el-radio>
                                    </el-radio-group>
                                  </span>
                                </p>
                                <p style="height: 75px">
                                  不符合事实：
                                  <el-input
                                    v-model="xm3_2_1Panding_9"
                                    class="xm3_2_1Panding_9"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </div>
                            </div>
                          </div>
                          <div v-if="id10" ref="id10" class="id10">
                            <el-tag type="success" @click="changeShow('xm10')">
                              <div class="leftSum">3.2.2内部审核内容</div>
                              <div class="danxiang">
                                <el-checkbox-group
                                  v-model="xm3_2_2Panding"
                                  @change="
                                    setMealSelect($event, 'xm3_2_2P', 'id10')
                                  "
                                >
                                  <el-checkbox-button
                                    v-for="option in threeOptions"
                                    :key="option"
                                    :label="option"
                                  >
                                    {{ option }}
                                  </el-checkbox-button>
                                </el-checkbox-group>
                              </div>
                            </el-tag>
                            <div ref="xm10" class="xiangmu">
                              <div class="neirong">
                                <p style="height: 85px">
                                  内部审核是否包括了以下内容：
                                  <span class="xm3_2_2Panding_1">
                                    <el-checkbox-group
                                      v-model="xm3_2_2Panding_1"
                                    >
                                      <el-checkbox label="01">
                                        原材料、外购（外协）件的供应商管理
                                      </el-checkbox>

                                      <el-checkbox label="02">
                                        材料、外购（外协）件的检验与验收
                                      </el-checkbox>

                                      <el-checkbox label="03">
                                        生产过程控制
                                      </el-checkbox>

                                      <el-checkbox label="04">
                                        关键工序控制
                                      </el-checkbox>

                                      <el-checkbox label="05">
                                        出厂检验
                                      </el-checkbox>

                                      <el-checkbox label="06">
                                        不合格品控制
                                      </el-checkbox>

                                      <el-checkbox label="07">
                                        用户反馈意见
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>
                                <p>
                                  最近一次内审时间：
                                  <el-date-picker
                                    v-model="xm3_2_2Panding_2"
                                    type="date"
                                    placeholder="选择日期"
                                    format="yyyy-MM-dd"
                                  ></el-date-picker>
                                </p>
                                <p>
                                  内审员
                                  <el-input
                                    v-model="xm3_2_2Panding_3"
                                    class="xm3_2_2Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  内审不符合项数：
                                  <el-input
                                    v-model="xm3_2_2Panding_4"
                                    class="xm3_2_2Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  主要不符合项内容（描述不多于3项即可）：
                                  <el-input
                                    v-model="xm3_2_2Panding_5"
                                    class="xm3_2_2Panding_5"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="不符合项内容"
                                    clearable
                                  ></el-input>
                                </p>
                                <p style="height: 75px">
                                  不符合事实：
                                  <el-input
                                    v-model="xm3_2_2Panding_6"
                                    class="xm3_2_2Panding_6"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </div>
                            </div>
                          </div>
                          <div v-if="id11" ref="id11" class="id11">
                            <el-tag type="success" @click="changeShow('xm11')">
                              <div class="leftSum">3.2.3管理评审内容</div>
                              <div class="danxiang">
                                <el-checkbox-group
                                  v-model="xm3_2_3Panding"
                                  @change="
                                    setMealSelect($event, 'xm3_2_3P', 'id11')
                                  "
                                >
                                  <el-checkbox-button
                                    v-for="option in threeOptions"
                                    :key="option"
                                    :label="option"
                                  >
                                    {{ option }}
                                  </el-checkbox-button>
                                </el-checkbox-group>
                              </div>
                            </el-tag>
                            <div ref="xm11" class="xiangmu">
                              <div class="neirong">
                                <p>
                                  管理评审是否包括:
                                  <span class="xm3_2_3Panding_1">
                                    <el-checkbox-group
                                      v-model="xm3_2_3Panding_1"
                                    >
                                      <el-checkbox label="01">
                                        近期内审和外审的结果
                                      </el-checkbox>
                                      <el-checkbox label="02">
                                        纠正与预防措施实施情况
                                      </el-checkbox>
                                      <el-checkbox label="03">
                                        获得安全标志产品质量状况
                                      </el-checkbox>
                                      <el-checkbox label="04">
                                        上次管理评审决定和措施的执行情况
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>
                                <p>
                                  最近一次管理评审时间：

                                  <el-date-picker
                                    v-model="xm3_2_3Panding_2"
                                    type="date"
                                    placeholder="选择日期"
                                    format="yyyy-MM-dd"
                                  ></el-date-picker>
                                </p>
                                <p style="height: 75px">
                                  不符合事实：
                                  <el-input
                                    v-model="xm3_2_3Panding_3"
                                    class="xm3_2_3Panding_3"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </div>
                            </div>
                          </div>
                          <div v-if="id12" ref="id12" class="id12">
                            <el-tag type="success" @click="changeShow('xm12')">
                              <div class="leftSum">3.2.4发现问题纠正</div>
                              <div class="danxiang">
                                <el-checkbox-group
                                  v-model="xm3_2_4Panding"
                                  @change="
                                    setMealSelect($event, 'xm3_2_4P', 'id12')
                                  "
                                >
                                  <el-checkbox-button
                                    v-for="option in twoOptions"
                                    :key="option"
                                    :label="option"
                                  >
                                    {{ option }}
                                  </el-checkbox-button>
                                </el-checkbox-group>
                              </div>
                            </el-tag>
                            <div ref="xm12" class="xiangmu">
                              <div class="neirong">
                                <p>
                                  对发现的问题,是否制定纠正措施,及时进行纠正,并对实施效果进行跟踪验证？
                                  <span class="xm3_2_4Panding_1">
                                    <el-radio-group v-model="xm3_2_4Panding_1">
                                      <el-radio label="是">是</el-radio>
                                      <el-radio label="否">否</el-radio>
                                    </el-radio-group>
                                  </span>
                                </p>

                                <p style="height: 75px">
                                  不符合事实：
                                  <el-input
                                    v-model="xm3_2_4Panding_2"
                                    class="xm3_2_4Panding_2"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id13" name="tab4" label="4管理职责">
            <el-row>
              <!--第四项-->
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id13" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm13')">
                    <div class="leftSum id13">
                      <vab-icon
                        :icon="['fas', 'dice-d20']"
                        style="color: #95de64"
                      ></vab-icon>
                      4管理职责
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_4JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      <div>
                        共
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm4Count }}
                        </el-tag>
                        项,其中,否决项
                        <el-tag
                          type="danger"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm4Foujue }}
                        </el-tag>
                        ,考核项
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm4Count - xm4Foujue }}
                        </el-tag>
                        项。
                      </div>
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm4hege == '0' ? 'info' : 'success'">
                          {{ xm4hege }}合格
                        </el-tag>

                        <el-tag :type="xm4jibenhege == '0' ? 'info' : 'danger'">
                          {{ xm4jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm4buhege == '0' ? 'info' : 'danger'">
                          {{ xm4buhege }}不合格
                        </el-tag>

                        <el-tag
                          v-if="hide_panding"
                          :type="xm4bushiyong == '0' ? 'info' : 'danger'"
                        >
                          {{ xm4bushiyong }}不适用
                        </el-tag>

                        <el-tag :type="xm4weipan == '0' ? 'info' : 'danger'">
                          {{ xm4weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm13" class="xiangmu">
                    <div v-if="id14" ref="id14" class="id14">
                      <el-tag
                        v-if="id14"
                        type="danger"
                        @click="changeShow('xm14')"
                      >
                        <div class="leftSum">4.1安标工作负责人</div>

                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm4_1Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm4_1Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm4_1Count - xm4_1Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm4_1hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm4_1jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm4_1buhege }}不合格
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm4_1bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm4_1weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div v-if="id14" ref="xm14" class="xiangmu">
                        <div v-if="id15" ref="id15" class="id15">
                          <el-tag type="success" @click="changeShow('xm15')">
                            <div class="leftSum">4.1.1指定安标工作负责人</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm4_1_1Panding"
                                @change="
                                  setMealSelect($event, 'xm4_1_1P', 'id15')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm15" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否在管理层内指定人员负责安全标志相关工作？
                                <span class="xm4_1_1Panding_1">
                                  <el-radio-group v-model="xm4_1_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                安标工作负责人姓名：
                                <el-input
                                  v-model="xm4_1_1Panding_2"
                                  class="xm4_1_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                职务：
                                <el-input
                                  v-model="xm4_1_1Panding_3"
                                  class="xm4_1_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                是否明确了安标工作负责人的职责？
                                <span class="xm4_1_1Panding_4">
                                  <el-radio-group v-model="xm4_1_1Panding_4">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                任命文件名称：
                                <el-input
                                  v-model="xm4_1_1Panding_5"
                                  class="xm4_1_1Panding_5"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号或日期：
                                <el-input
                                  v-model="xm4_1_1Panding_6"
                                  class="xm4_1_1Panding_6"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                职责是否包括以下内容：
                                <span class="xm4_1_1Panding_7 jianjieSpan">
                                  <el-checkbox-group v-model="xm4_1_1Panding_7">
                                    <p>
                                      <el-checkbox label="01">
                                        确保工厂质量保证能力满足本规则要求
                                      </el-checkbox>
                                    </p>
                                    <p>
                                      <el-checkbox label="02">
                                        确保生产产品符合安标备案技术文件要求,并与安标检验样品一致
                                      </el-checkbox>
                                    </p>
                                    <p>
                                      <el-checkbox label="03">
                                        <span
                                          class="jianjieSpan"
                                          style="width:padding-right:10px;"
                                        >
                                          确保在工商注册信息、生产地址以及其他可能影响产品一致性（如工艺、生产条件、主要零（元）部件和重要原材料和产品结构等）的发生变更时,严格执行安标变更管理的相关要求
                                        </span>
                                      </el-checkbox>
                                    </p>
                                    <p>
                                      <el-checkbox label="04">
                                        了解安全标志证书和标识的使用要求,以及安全标志证书注销、暂停、撤销的条件,确保安全标志证书和标识的正确使用
                                      </el-checkbox>
                                    </p>
                                    <p>
                                      <el-checkbox label="05">
                                        协调工厂生产各环节和部门涉及安标申办、监督检查的相关事宜
                                      </el-checkbox>
                                    </p>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p>
                                不符合事实：
                                <el-input
                                  v-model="xm4_1_1Panding_8"
                                  class="xm4_1_1Panding_8"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id16" ref="id16" class="id16">
                          <el-tag type="success" @click="changeShow('xm16')">
                            <div class="leftSum">4.1.2熟悉职责落实要求</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm4_1_2Panding"
                                @change="
                                  setMealSelect($event, 'xm4_1_2P', 'id16')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm16" class="xiangmu">
                            <div class="neirong">
                              <p>
                                安标工作负责人是否熟悉其职责,并落实相关内容要求？
                                <span class="xm4_1_2Panding_1">
                                  <el-radio-group v-model="xm4_1_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm4_1_2Panding_2"
                                  class="xm4_1_2Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id17" ref="id17" class="id17">
                      <el-tag
                        v-if="id17"
                        type="danger"
                        @click="changeShow('xm17')"
                      >
                        <div class="leftSum">4.2安标联系人</div>

                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm4_2Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm4_2Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm4_2Count - xm4_2Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm4_2hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm4_2jibenhege }}基本
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm4_2buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm4_2bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm4_2weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div v-if="id17" ref="xm17" class="xiangmu">
                        <div v-if="id18" ref="id18" class="id18">
                          <el-tag type="success" @click="changeShow('xm18')">
                            <div class="leftSum">4.2.1指定安标联系人</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm4_2_1Panding"
                                @change="
                                  setMealSelect($event, 'xm4_2_1P', 'id18')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm18" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否在工厂内部指定安标联系人？
                                <span class="xm4_2_1Panding_1">
                                  <el-radio-group v-model="xm4_2_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                安标联系人姓名：
                                <el-input
                                  v-model="xm4_2_1Panding_2"
                                  class="xm4_2_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                职务：
                                <el-input
                                  v-model="xm4_2_1Panding_3"
                                  class="xm4_2_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                是否明确了安标联系人的职责？
                                <span class="xm4_2_1Panding_4">
                                  <el-radio-group v-model="xm4_2_1Panding_4">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                任命文件名称：
                                <el-input
                                  v-model="xm4_2_1Panding_5"
                                  class="xm4_2_1Panding_5"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号或日期：
                                <el-input
                                  v-model="xm4_2_1Panding_6"
                                  class="xm4_2_1Panding_6"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                职责是否包括以下内容：
                                <span class="xm4_2_1Panding_7 jianjieSpan">
                                  <el-checkbox-group v-model="xm4_2_1Panding_7">
                                    <p>
                                      <el-checkbox label="01">
                                        负责安全标志的申办,及时跟踪申办进度并保证与安标国家中心、检测检验机构的有效沟通
                                      </el-checkbox>
                                    </p>
                                    <p>
                                      <el-checkbox label="02">
                                        及时关注安标网站及企业会员区动态信息,跟踪、了解安全标志审核发放实施规则换版、产品标准换版及其他相关文件的发布、修订情况
                                      </el-checkbox>
                                    </p>
                                    <p>
                                      <el-checkbox label="03">
                                        跟踪监督检查结果
                                      </el-checkbox>
                                    </p>
                                    <p>
                                      <el-checkbox label="04">
                                        持证人工商注册信息、生产地址、获证产品发生变更时,负责与安标国家中心联系,履行变更程序
                                      </el-checkbox>
                                    </p>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p>
                                不符合事实：
                                <el-input
                                  v-model="xm4_2_1Panding_8"
                                  class="xm4_2_1Panding_8"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id19" ref="id19" class="id19">
                          <el-tag type="success" @click="changeShow('xm19')">
                            <div class="leftSum">4.2.2安标联系人落实职责</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm4_2_2Panding"
                                @change="
                                  setMealSelect($event, 'xm4_2_2P', 'id19')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm19" class="xiangmu">
                            <div class="neirong">
                              <p>
                                安标联系人是否熟悉其职责,并落实相关内容要求？
                                <span class="xm4_2_2Panding_1">
                                  <el-radio-group v-model="xm4_2_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm4_2_2Panding_2"
                                  class="xm4_2_2Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div ref="id20" class="id20">
                          <el-tag
                            v-if="id20"
                            type="danger"
                            @click="changeShow('xm20')"
                          >
                            <div class="leftSum">4.3其他人员</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm4_3Panding"
                                @change="
                                  setMealSelect($event, 'xm4_3P', 'id20')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div v-if="id20" ref="xm20" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否指定并明确以下人员的职责权限,并保证其工作独立性？
                                <span class="xm4_3Panding_1">
                                  <el-checkbox-group v-model="xm4_3Panding_1">
                                    <el-checkbox label="01">
                                      质量负责人
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      检验人员
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      不合格品处置负责人
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  质量负责人姓名
                                  <el-input
                                    v-model="xm4_3Panding_2"
                                    class="xm4_3Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                                <p>
                                  任命文件名称
                                  <el-input
                                    v-model="xm4_3Panding_3"
                                    class="xm4_3Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                  编号或日期：
                                  <el-input
                                    v-model="xm4_3Panding_4"
                                    class="xm4_3Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <el-card>
                                <p>
                                  检验人员姓名
                                  <el-input
                                    v-model="xm4_3Panding_5"
                                    class="xm4_3Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                                <p>
                                  任命文件名称
                                  <el-input
                                    v-model="xm4_3Panding_6"
                                    class="xm4_3Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                  编号或日期：
                                  <el-input
                                    v-model="xm4_3Panding_7"
                                    class="xm4_3Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <el-card>
                                <p>
                                  不合格品处置负责人姓名
                                  <el-input
                                    v-model="xm4_3Panding_8"
                                    class="xm4_3Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                                <p>
                                  任命文件名称
                                  <el-input
                                    v-model="xm4_3Panding_9"
                                    class="xm4_3Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                  编号或日期：
                                  <el-input
                                    v-model="xm4_3Panding_10"
                                    class="xm4_3Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p>
                                以上人员是否具备相应能力？
                                <span class="xm4_3Panding_11">
                                  <el-radio-group v-model="xm4_3Panding_11">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm4_3Panding_12"
                                  class="xm4_3Panding_12"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id21" name="tab5" label="5人员能力">
            <el-row>
              <!--第五项-->
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id21" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm21')">
                    <div class="leftSum id21">
                      <vab-icon
                        :icon="['fas', 'city']"
                        style="color: #95de64"
                      ></vab-icon>
                      5人员能力
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_5JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      <div>
                        共
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm5Count }}
                        </el-tag>
                        项,其中,否决项
                        <el-tag
                          type="danger"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm5Foujue }}
                        </el-tag>
                        ,考核项
                        <el-tag
                          type="success"
                          style="margin-left: 0px; margin-right: 0px"
                        >
                          {{ xm5Count - xm5Foujue }}
                        </el-tag>
                        项。
                      </div>
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm5hege == '0' ? 'info' : 'success'">
                          {{ xm5hege }}合格
                        </el-tag>

                        <el-tag :type="xm5jibenhege == '0' ? 'info' : 'danger'">
                          {{ xm5jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm5buhege == '0' ? 'info' : 'danger'">
                          {{ xm5buhege }}不合格
                        </el-tag>

                        <el-tag
                          v-if="hide_panding"
                          :type="xm5bushiyong == '0' ? 'info' : 'danger'"
                        >
                          {{ xm5bushiyong }}不适用
                        </el-tag>

                        <el-tag :type="xm5weipan == '0' ? 'info' : 'danger'">
                          {{ xm5weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm21" class="xiangmu">
                    <div v-if="id22" ref="id22" class="id22">
                      <el-tag
                        v-if="id22"
                        type="danger"
                        @click="changeShow('xm22')"
                      >
                        <div class="leftSum">5.1主要负责人</div>

                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm5_1Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_1Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_1Count - xm5_1Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm5_1hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm5_1jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_1buhege }}不合格
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm5_1bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_1weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div v-if="id22" ref="xm22" class="xiangmu">
                        <div v-if="id23" ref="id23" class="id23">
                          <el-tag type="success" @click="changeShow('xm23')">
                            <div class="leftSum">5.1.1了解产品特殊要求</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_1_1Panding"
                                @change="
                                  setMealSelect($event, 'xm5_1_1P', 'id23')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm23" class="xiangmu">
                            <div class="neirong">
                              <p>
                                主要负责人是否基本了解矿山使用环境对产品的特殊要求？
                                <span class="xm5_1_1Panding_1">
                                  <el-radio-group v-model="xm5_1_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                被考核人员姓名：
                                <el-input
                                  v-model="xm5_1_1Panding_2"
                                  class="xm5_1_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                职务：
                                <el-input
                                  v-model="xm5_1_1Panding_3"
                                  class="xm5_1_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                不符合事实：
                                <el-input
                                  v-model="xm5_1_1Panding_4"
                                  class="xm5_1_1Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id24" ref="id24" class="id24">
                          <el-tag type="success" @click="changeShow('xm24')">
                            <div class="leftSum">
                              5.1.2熟悉影响因素掌握控制措施和现状
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_1_2Panding"
                                @change="
                                  setMealSelect($event, 'xm5_1_2P', 'id24')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm24" class="xiangmu">
                            <div class="neirong">
                              <p>
                                技术负责人是否熟悉影响产品安全性能的相关因素,掌握工厂对各要素控制措施和现状？
                                <span class="xm5_1_2Panding_1">
                                  <el-radio-group v-model="xm5_1_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card shadow="never">
                                <p>
                                  被考核人员姓名：
                                  <el-input
                                    v-model="xm5_1_2Panding_2"
                                    class="xm5_1_2Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  职务：
                                  <el-input
                                    v-model="xm5_1_2Panding_3"
                                    class="xm5_1_2Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容1:
                                  <el-input
                                    v-model="xm5_1_2Panding_4"
                                    class="xm5_1_2Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_1_2Panding_5"
                                    class="xm5_1_2Panding_5"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容2:
                                  <el-input
                                    v-model="xm5_1_2Panding_6"
                                    class="xm5_1_2Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_1_2Panding_7"
                                    class="xm5_1_2Panding_7"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm5_1_2Panding_8"
                                  class="xm5_1_2Panding_8"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id25" ref="id25" class="id25">
                      <el-tag
                        v-if="id25"
                        type="danger"
                        @click="changeShow('xm25')"
                      >
                        <div class="leftSum">5.2技术人员</div>

                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm5_2Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_2Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_2Count - xm5_2Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm5_2hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm5_2jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_2buhege }}不合格
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm5_2bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_2weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div v-if="id25" ref="xm25" class="xiangmu">
                        <div v-if="id26" ref="id26" class="id26">
                          <el-tag type="success" @click="changeShow('xm26')">
                            <div class="leftSum">5.2.1 掌握产品标准及要求</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_2_1Panding"
                                @change="
                                  setMealSelect($event, 'xm5_2_1P', 'id26')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm26" class="xiangmu">
                            <div class="neirong">
                              <p>
                                技术人员是否熟练掌握产品标准及相关要求？
                                <span class="xm5_2_1Panding_1">
                                  <el-radio-group v-model="xm5_2_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card shadow="never">
                                <p>
                                  被考核人员姓名1:
                                  <el-input
                                    v-model="xm5_2_1Panding_2"
                                    class="xm5_2_1Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  岗位：
                                  <el-input
                                    v-model="xm5_2_1Panding_3"
                                    class="xm5_2_1Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_2_1Panding_4">
                                    <el-checkbox-group
                                      v-model="xm5_2_1Panding_4"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                      <el-checkbox label="02">
                                        车间讲解
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>
                                <p>
                                  考核内容1:
                                  <el-input
                                    v-model="xm5_2_1Panding_5"
                                    class="xm5_2_1Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_2_1Panding_6"
                                    class="xm5_2_1Panding_6"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容2:
                                  <el-input
                                    v-model="xm5_2_1Panding_7"
                                    class="xm5_2_1Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_2_1Panding_8"
                                    class="xm5_2_1Panding_8"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容3:
                                  <el-input
                                    v-model="xm5_2_1Panding_9"
                                    class="xm5_2_1Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_2_1Panding_10"
                                    class="xm5_2_1Panding_10"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>
                              <el-card shadow="never">
                                <p>
                                  被考核人员姓名2:
                                  <el-input
                                    v-model="xm5_2_1Panding_11"
                                    class="xm5_2_1Panding_11"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  岗位：
                                  <el-input
                                    v-model="xm5_2_1Panding_12"
                                    class="xm5_2_1Panding_12"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式

                                  <span class="xm5_2_1Panding_13">
                                    <el-checkbox-group
                                      v-model="xm5_2_1Panding_13"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                      <el-checkbox label="02">
                                        车间讲解
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>
                                <p>
                                  考核内容1:
                                  <el-input
                                    v-model="xm5_2_1Panding_14"
                                    class="xm5_2_1Panding_14"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_2_1Panding_15"
                                    class="xm5_2_1Panding_15"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容2:
                                  <el-input
                                    v-model="xm5_2_1Panding_16"
                                    class="xm5_2_1Panding_16"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_2_1Panding_17"
                                    class="xm5_2_1Panding_17"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容3:
                                  <el-input
                                    v-model="xm5_2_1Panding_18"
                                    class="xm5_2_1Panding_18"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  回答要点：
                                  <el-input
                                    v-model="xm5_2_1Panding_19"
                                    class="xm5_2_1Panding_19"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>

                              <p>
                                不符合事实：
                                <el-input
                                  v-model="xm5_2_1Panding_20"
                                  class="xm5_2_1Panding_20"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id27" ref="id27" class="id27">
                          <el-tag type="success" @click="changeShow('xm27')">
                            <div class="leftSum">
                              5.2.2技术人员是否为全职人员
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_2_2Panding"
                                @change="
                                  setMealSelect($event, 'xm5_2_2P', 'id27')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm27" class="xiangmu">
                            <div class="neirong">
                              <p>
                                技术人员是否为全职人员
                                <span class="xm5_2_2Panding_1">
                                  <el-radio-group v-model="xm5_2_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                技术人员数量、专业经验、能力是否满足生产需求？
                                <span class="xm5_2_2Panding_2">
                                  <el-radio-group v-model="xm5_2_2Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm5_2_2Panding_3"
                                  class="xm5_2_2Panding_3"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                技术人员信息一览表见附表1。劳动合同、职称证书或毕业证书需拍照取证,保存在文件夹“技术人员”。
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id28" ref="id28" class="id28">
                      <el-tag
                        v-if="id28"
                        type="danger"
                        @click="changeShow('xm28')"
                      >
                        <div class="leftSum">5.3技术人员</div>

                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm5_3Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_3Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_3Count - xm5_3Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm5_3hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm5_3jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_3buhege }}不合格
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm5_3bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_3weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div v-if="id28" ref="xm28" class="xiangmu">
                        <div v-if="id29" ref="id29" class="id29">
                          <el-tag type="success" @click="changeShow('xm29')">
                            <div class="leftSum">5.3.1熟悉生产工艺</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_3_1Panding"
                                @change="
                                  setMealSelect($event, 'xm5_3_1P', 'id29')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm29" class="xiangmu">
                            <div class="neirong">
                              <p>
                                关键工序的操作人员是否熟悉其生产工艺、设备操作规程等内容？
                                <span class="xm5_3_1Panding_1">
                                  <el-radio-group v-model="xm5_3_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card shadow="never">
                                <p>
                                  被考核工序:
                                  <el-input
                                    v-model="xm5_3_1Panding_2"
                                    class="xm5_3_1Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  人员姓名
                                  <el-input
                                    v-model="xm5_3_1Panding_3"
                                    class="xm5_3_1Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_3_1Panding_4">
                                    <el-checkbox-group
                                      v-model="xm5_3_1Panding_4"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>

                                <p>
                                  考核内容1
                                  <el-input
                                    v-model="xm5_3_1Panding_5"
                                    class="xm5_3_1Panding_5"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>

                                <p>
                                  考核内容2
                                  <el-input
                                    v-model="xm5_3_1Panding_6"
                                    class="xm5_3_1Panding_6"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>

                              <p>
                                不符合事实：
                                <el-input
                                  v-model="xm5_3_1Panding_7"
                                  class="xm5_3_1Panding_7"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id30" ref="id30" class="id30">
                          <el-tag type="success" @click="changeShow('xm30')">
                            <div class="leftSum">5.3.2熟练操作设备</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_3_2Panding"
                                @change="
                                  setMealSelect($event, 'xm5_3_2P', 'id30')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm30" class="xiangmu">
                            <div class="neirong">
                              <p>
                                关键工序人员是否熟练操作相关设备,对生产工艺过程及产品的关键控制参数能够正确检测和判定？
                                <span class="xm5_3_2Panding_1">
                                  <el-radio-group v-model="xm5_3_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card shadow="never">
                                <p>
                                  被考核工序:
                                  <el-input
                                    v-model="xm5_3_2Panding_2"
                                    class="xm5_3_2Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  人员姓名
                                  <el-input
                                    v-model="xm5_3_2Panding_3"
                                    class="xm5_3_2Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_3_2Panding_4">
                                    <el-checkbox-group
                                      v-model="xm5_3_2Panding_4"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                      <el-checkbox label="02">
                                        现场操作
                                      </el-checkbox>
                                      <el-checkbox label="03">
                                        模拟操作
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>

                                <p>
                                  考核内容1
                                  <el-input
                                    v-model="xm5_3_2Panding_5"
                                    class="xm5_3_2Panding_5"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>

                                <p>
                                  考核内容2
                                  <el-input
                                    v-model="xm5_3_2Panding_6"
                                    class="xm5_3_2Panding_6"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>

                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm5_3_2Panding_7"
                                  class="xm5_3_2Panding_7"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id31" ref="id31" class="id31">
                      <el-tag
                        v-if="id31"
                        type="danger"
                        @click="changeShow('xm31')"
                      >
                        <div class="leftSum">5.4检验人员</div>

                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm5_4Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_4Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_4Count - xm5_4Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm5_4hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm5_4jibenhege }}基本
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm5_4buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm5_4bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm5_4weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div v-if="id31" ref="xm31" class="xiangmu">
                        <div v-if="id32" ref="id32" class="id32">
                          <el-tag type="success" @click="changeShow('xm32')">
                            <div class="leftSum">5.4.1熟悉检验规程</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_4_1Panding"
                                @change="
                                  setMealSelect($event, 'xm5_4_1P', 'id32')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm32" class="xiangmu">
                            <div class="neirong">
                              <p>
                                检验人员是否熟悉产品标准、检验规程的相关要求？
                                <span class="xm5_4_1Panding_1">
                                  <el-radio-group v-model="xm5_4_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                该企业共有检验员
                                <el-input
                                  v-model="xm5_4_1Panding_2"
                                  class="xm5_4_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 30%"
                                ></el-input>
                                名
                              </p>
                              <el-card shadow="never">
                                <el-tag class="element" type="error">
                                  入厂检验
                                </el-tag>

                                <p>
                                  被考核入厂检验人员姓名:
                                  <el-input
                                    v-model="xm5_4_1Panding_3"
                                    class="xm5_4_1Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 60%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_4_1Panding_4">
                                    <el-checkbox-group
                                      v-model="xm5_4_1Panding_4"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>

                                <p>
                                  考核内容1
                                  <el-input
                                    v-model="xm5_4_1Panding_5"
                                    class="xm5_4_1Panding_5"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>
                              <el-card shadow="never">
                                <el-tag class="element" type="error">
                                  过程检验
                                </el-tag>
                                <p>
                                  被考核过程检验人员姓名:
                                  <el-input
                                    v-model="xm5_4_1Panding_6"
                                    class="xm5_4_1Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 60%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_4_1Panding_7">
                                    <el-checkbox-group
                                      v-model="xm5_4_1Panding_7"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>
                                <p>
                                  考核内容1
                                  <el-input
                                    v-model="xm5_4_1Panding_8"
                                    class="xm5_4_1Panding_8"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容2
                                  <el-input
                                    v-model="xm5_4_1Panding_9"
                                    class="xm5_4_1Panding_9"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>
                              <el-card shadow="never">
                                <el-tag class="element" type="error">
                                  出厂检验
                                </el-tag>
                                <p>
                                  被考核出厂检验人员姓名:
                                  <el-input
                                    v-model="xm5_4_1Panding_10"
                                    class="xm5_4_1Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 60%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_4_1Panding_11">
                                    <el-checkbox-group
                                      v-model="xm5_4_1Panding_11"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>

                                <p>
                                  考核内容1
                                  <el-input
                                    v-model="xm5_4_1Panding_12"
                                    class="xm5_4_1Panding_12"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                                <p>
                                  考核内容2
                                  <el-input
                                    v-model="xm5_4_1Panding_13"
                                    class="xm5_4_1Panding_13"
                                    type="textarea"
                                    :rows="2"
                                    placeholder="请输入不合格事实"
                                    clearable
                                  ></el-input>
                                </p>
                              </el-card>
                              <p>
                                不符合事实：
                                <el-input
                                  v-model="xm5_4_1Panding_14"
                                  class="xm5_4_1Panding_14"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id33" ref="id33" class="id33">
                          <el-tag type="success" @click="changeShow('xm33')">
                            <div class="leftSum">5.4.2熟练操作设备</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm5_4_2Panding"
                                @change="
                                  setMealSelect($event, 'xm5_4_2P', 'id33')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm33" class="xiangmu">
                            <div class="neirong">
                              <p>
                                检验人员是否能正确、熟练地按要求使用检测检验设备？
                                <span class="xm5_4_2Panding_1">
                                  <el-radio-group v-model="xm5_4_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card shadow="never">
                                <el-tag class="element" type="error">
                                  入厂检验
                                </el-tag>

                                <p>
                                  被考核入厂检验人员姓名:
                                  <el-input
                                    v-model="xm5_4_2Panding_2"
                                    class="xm5_4_2Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 50%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_4_2Panding_3">
                                    <el-checkbox-group
                                      v-model="xm5_4_2Panding_3"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                      <el-checkbox label="02">
                                        现场操作
                                      </el-checkbox>
                                      <el-checkbox label="03">
                                        模拟操作
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>

                                <p>
                                  考核操作的检测检验设备：
                                  <el-input
                                    v-model="xm5_4_2Panding_4"
                                    class="xm5_4_2Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 60%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <el-card shadow="never">
                                <el-tag class="element" type="error">
                                  过程检验
                                </el-tag>

                                <p>
                                  被考核过程检验人员姓名:
                                  <el-input
                                    v-model="xm5_4_2Panding_5"
                                    class="xm5_4_2Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 50%"
                                  ></el-input>
                                </p>
                                <p>
                                  考核方式
                                  <span class="xm5_4_2Panding_6">
                                    <el-checkbox-group
                                      v-model="xm5_4_2Panding_6"
                                    >
                                      <el-checkbox label="01">
                                        技术交流
                                      </el-checkbox>
                                      <el-checkbox label="02">
                                        现场操作
                                      </el-checkbox>
                                      <el-checkbox label="03">
                                        现场操作
                                      </el-checkbox>
                                    </el-checkbox-group>
                                  </span>
                                </p>

                                <p>
                                  考核操作的检测检验设备：
                                  <el-input
                                    v-model="xm5_4_2Panding_7"
                                    class="xm5_4_2Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 60%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <el-card shadow="never">
                                <el-tag class="element" type="error">
                                  出厂检验
                                </el-tag>

                                <p>
                                  被考核出厂检验人员姓名:
                                  <el-input
                                    v-model="xm5_4_2Panding_8"
                                    class="xm5_4_2Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 50%"
                                  ></el-input>
                                </p>
                                <p>
                                  <el-checkbox-group v-model="xm5_4_2Panding_9">
                                    <el-checkbox label="01">
                                      技术交流
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      现场操作
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      模拟操作
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </p>

                                <p>
                                  考核操作的检测检验设备：
                                  <el-input
                                    v-model="xm5_4_2Panding_10"
                                    class="xm5_4_2Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 60%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm5_4_2Panding_11"
                                  class="xm5_4_2Panding_11"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id34" ref="id34" class="id34">
                      <el-tag
                        v-if="id34"
                        type="danger"
                        @click="changeShow('xm34')"
                      >
                        <div class="leftSum">5.5培训考核</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm5_5Panding"
                            @change="setMealSelect($event, 'xm5_5P', 'id34')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div v-if="id34" ref="xm34" class="xiangmu">
                        <div class="neirong">
                          <p>
                            与产品质量控制相关的技术、加工、组装、检验等人员是否经培训、考核合格？
                            <span class="xm5_5Panding_1">
                              <el-radio-group v-model="xm5_5Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            培训签到表、培训记录、考核方式等是否齐全、有效？
                            <span class="xm5_5Panding_2">
                              <el-radio-group v-model="xm5_5Panding_2">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>

                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm5_5Panding_3"
                              class="xm5_5Panding_3"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id35" name="tab6" label="6文件管理和记录">
            <!--第6项-->
            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id35" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm35')">
                    <div class="leftSum id35">
                      <vab-icon
                        :icon="['fas', 'clinic-medical']"
                        style="color: #95de64"
                      ></vab-icon>
                      6文件管理和记录
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_6JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm6Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm6Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm6Count - xm6Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm6hege == '0' ? 'info' : 'success'">
                          {{ xm6hege }}合格
                        </el-tag>

                        <el-tag :type="xm6jibenhege == '0' ? 'info' : 'danger'">
                          {{ xm6jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm6buhege == '0' ? 'info' : 'danger'">
                          {{ xm6buhege }}不合格
                        </el-tag>

                        <el-tag
                          v-if="hide_panding"
                          :type="xm6bushiyong == '0' ? 'info' : 'danger'"
                        >
                          {{ xm6bushiyong }}不适用
                        </el-tag>

                        <el-tag :type="xm6weipan == '0' ? 'info' : 'danger'">
                          {{ xm6weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm35" class="xiangmu">
                    <div v-if="id36" ref="id36" class="id36">
                      <el-tag type="success" @click="changeShow('xm36')">
                        <div class="leftSum id36">6.1文件控制</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm6_1Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_1Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_1Count - xm6_1Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm6_1hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm6_1jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_1buhege }}不合格
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm6_1bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_1weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm36" class="xiangmu">
                        <div v-if="id37" ref="id37" class="id37">
                          <el-tag
                            v-if="id37"
                            type="danger"
                            @click="changeShow('xm37')"
                          >
                            <div class="leftSum id37">
                              6.1.1建立文件管理制度
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm6_1_1Panding"
                                @change="
                                  setMealSelect($event, 'xm6_1_1P', 'id37')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm37" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否建立文件管理制度
                                <span class="xm6_1_1Panding_1">
                                  <el-radio-group v-model="xm6_1_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                文件名称:
                                <el-input
                                  v-model="xm6_1_1Panding_2"
                                  class="xm6_1_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm6_1_1Panding_3"
                                  class="xm6_1_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                是否能确保所有涉及申办产品的技术文件和资料（如产品相关标准、技术要求、图纸、工艺文件等）纳入受控管理？
                                <span class="xm6_1_1Panding_4">
                                  <el-radio-group v-model="xm6_1_1Panding_4">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm6_1_1Panding_5"
                                  class="xm6_1_1Panding_5"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id38" ref="id38" class="id38">
                          <el-tag
                            v-if="id38"
                            type="danger"
                            @click="changeShow('xm38')"
                          >
                            <div class="leftSum id38">
                              6.1.2技术文件和资料的可追溯记录
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm6_1_2Panding"
                                @change="
                                  setMealSelect($event, 'xm6_1_2P', 'id38')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm38" class="xiangmu">
                            <div class="neirong">
                              <p>
                                技术文件和资料的编制、审核、批准、发放、使用、保管、更改和注销是否有完整可追溯记录？
                                <span class="xm6_1_2Panding_1">
                                  <el-radio-group v-model="xm6_1_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  审批文件名称:
                                  <el-input
                                    v-model="xm6_1_2Panding_2"
                                    class="xm6_1_2Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  编号或日期
                                  <el-input
                                    v-model="xm6_1_2Panding_3"
                                    class="xm6_1_2Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  发放记录名称:
                                  <el-input
                                    v-model="xm6_1_2Panding_4"
                                    class="xm6_1_2Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  编号或日期
                                  <el-input
                                    v-model="xm6_1_2Panding_5"
                                    class="xm6_1_2Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  更改记录名称:
                                  <el-input
                                    v-model="xm6_1_2Panding_6"
                                    class="xm6_1_2Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  编号或日期
                                  <el-input
                                    v-model="xm6_1_2Panding_7"
                                    class="xm6_1_2Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  注销记录名称:
                                  <el-input
                                    v-model="xm6_1_2Panding_8"
                                    class="xm6_1_2Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  编号或日期
                                  <el-input
                                    v-model="xm6_1_2Panding_9"
                                    class="xm6_1_2Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm6_1_2Panding_10"
                                  class="xm6_1_2Panding_10"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id39" ref="id39" class="id39">
                          <el-tag
                            v-if="id39"
                            type="danger"
                            @click="changeShow('xm39')"
                          >
                            <div class="leftSum id39">
                              6.1.3与安标备案技术文件的一致性
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm6_1_3Panding"
                                @change="
                                  setMealSelect($event, 'xm6_1_3P', 'id39')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm39" class="xiangmu">
                            <div class="neirong">
                              <p>
                                工厂相关部门、环节使用的技术文件其要求是否与安标备案技术文件的要求一致？
                                <span class="xm6_1_3Panding_1">
                                  <el-radio-group v-model="xm6_1_3Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  部门1名称:
                                  <el-input
                                    v-model="xm6_1_3Panding_2"
                                    class="xm6_1_3Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  文件名称
                                  <el-input
                                    v-model="xm6_1_3Panding_3"
                                    class="xm6_1_3Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  部门2名称:
                                  <el-input
                                    v-model="xm6_1_3Panding_4"
                                    class="xm6_1_3Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  文件名称
                                  <el-input
                                    v-model="xm6_1_3Panding_5"
                                    class="xm6_1_3Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm6_1_3Panding_6"
                                  class="xm6_1_3Panding_6"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id40" ref="id40" class="id40">
                          <el-tag
                            v-if="id40"
                            type="danger"
                            @click="changeShow('xm40')"
                          >
                            <div class="leftSum id40">
                              6.1.4安标相关文件资料妥善保存
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm6_1_4Panding"
                                @change="
                                  setMealSelect($event, 'xm6_1_4P', 'id40')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm40" class="xiangmu">
                            <div class="neirong">
                              <p style="height: 70px">
                                安标相关的以下文件资料是否妥善保存？
                                <span class="xm6_1_4Panding_1">
                                  <el-checkbox-group v-model="xm6_1_4Panding_1">
                                    <el-checkbox label="01">
                                      安标备案技术文件
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      产品检验报告
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      工厂评审报告及不符合项报告
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      产品变更（扩展）资料
                                    </el-checkbox>
                                    <el-checkbox label="05">
                                      安全标志证书
                                    </el-checkbox>
                                    <el-checkbox label="06">
                                      工厂评审专用要求中规定的必备标准等。
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm6_1_4Panding_2"
                                  class="xm6_1_4Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id41" ref="id41" class="id41">
                      <el-tag type="success" @click="changeShow('xm41')">
                        <div class="leftSum id41">6.2记录控制</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm6_2Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_2Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_2Count - xm6_2Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm6_2hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm6_2jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_2buhege }}不合格
                            </el-tag>

                            <el-tag v-if="hide_panding" type="danger">
                              {{ xm6_2bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm6_2weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm41" class="xiangmu">
                        <div v-if="id42" ref="id42" class="id42">
                          <el-tag
                            v-if="id42"
                            type="danger"
                            @click="changeShow('xm42')"
                          >
                            <div class="leftSum id42">
                              6.2.1建立记录管理制度
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm6_2_1Panding"
                                @change="
                                  setMealSelect($event, 'xm6_2_1P', 'id42')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm42" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否建立记录管理制度？
                                <span class="xm6_2_1Panding_1">
                                  <el-radio-group v-model="xm6_2_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                制度名称
                                <el-input
                                  v-model="xm6_2_1Panding_2"
                                  class="xm6_2_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm6_2_1Panding_3"
                                  class="xm6_2_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                能否确保生产、质量重要记录得到有效控制,各种记录的保存时间是否明确规定？
                                <span class="xm6_2_1Panding_4">
                                  <el-radio-group v-model="xm6_2_1Panding_4">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                采购（外协）记录保存时间是否不低于3年？
                                <span class="xm6_2_1Panding_5">
                                  <el-radio-group v-model="xm6_2_1Panding_5">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                出厂检验记录保存时间是否不低于5年？
                                <span class="xm6_2_1Panding_6">
                                  <el-radio-group v-model="xm6_2_1Panding_6">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                不合格品控制记录保存时间是否不低于5年？
                                <span class="xm6_2_1Panding_7">
                                  <el-radio-group v-model="xm6_2_1Panding_7">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm6_2_1Panding_8"
                                  class="xm6_2_1Panding_8"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id43" ref="id43" class="id43">
                          <el-tag
                            v-if="id43"
                            type="danger"
                            @click="changeShow('xm43')"
                          >
                            <div class="leftSum id43">
                              6.2.2对文件进行控制和保存
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm6_2_2Panding"
                                @change="
                                  setMealSelect($event, 'xm6_2_2P', 'id43')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm43" class="xiangmu">
                            <div class="neirong">
                              <p style="height: 120px">
                                是否对以下文件进行控制和保存？
                                <span class="xm6_2_2Panding_1">
                                  <el-checkbox-group v-model="xm6_2_2Panding_1">
                                    <el-checkbox label="01">
                                      法律法规要求的
                                    </el-checkbox>

                                    <el-checkbox label="02">
                                      订单（合同）
                                    </el-checkbox>

                                    <el-checkbox label="03">
                                      合同评审（必要时）
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      内部质量审核记录
                                    </el-checkbox>
                                    <el-checkbox label="05">
                                      管理评审记录
                                    </el-checkbox>
                                    <el-checkbox label="06">
                                      培训记录
                                    </el-checkbox>
                                    <el-checkbox label="07">
                                      技术文件（图纸、工艺等）更改记录
                                    </el-checkbox>
                                    <el-checkbox label="08">
                                      采购（外协）记录
                                    </el-checkbox>
                                    <el-checkbox label="09">
                                      验和测试记录（单台/件、每批次）
                                    </el-checkbox>
                                    <el-checkbox label="10">
                                      不合格品处置记录
                                    </el-checkbox>
                                    <el-checkbox label="11">
                                      检定/校准记录
                                    </el-checkbox>
                                    <el-checkbox label="12">
                                      供方评价
                                    </el-checkbox>
                                    <el-checkbox label="13">
                                      销售台账
                                    </el-checkbox>
                                    <el-checkbox label="14">
                                      用户的质量信息反馈记录
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p>
                                采购（外协）记录保存时间是否符合要求？
                                <span class="xm6_2_2Panding_2">
                                  <el-radio-group v-model="xm6_2_2Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                出厂检验记录保存时间是否符合要求？
                                <span class="xm6_2_2Panding_3">
                                  <el-radio-group v-model="xm6_2_2Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                不合格品控制记录保存时间是否符合要求？
                                <span class="xm6_2_2Panding_4">
                                  <el-radio-group v-model="xm6_2_2Panding_4">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm6_2_2Panding_5"
                                  class="xm6_2_2Panding_5"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id44" name="tab7" label="7采购与外协">
            <!--第7采购与外协项-->
            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id44" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm44')">
                    <div class="leftSum id44">
                      <vab-icon
                        :icon="['fas', 'coffee']"
                        style="color: #95de64"
                      ></vab-icon>
                      7采购与外协
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_7JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm7Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm7Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm7Count - xm7Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm7hege == '0' ? 'info' : 'success'">
                          {{ xm7hege }}合格
                        </el-tag>

                        <el-tag :type="xm7jibenhege == '0' ? 'info' : 'danger'">
                          {{ xm7jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm7buhege == '0' ? 'info' : 'danger'">
                          {{ xm7buhege }}不合格
                        </el-tag>

                        <el-tag type="info">{{ xm7bushiyong }}不适用</el-tag>

                        <el-tag :type="xm7weipan == '0' ? 'info' : 'danger'">
                          {{ xm7weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm44" class="xiangmu">
                    <div v-if="id45" ref="id45" class="id45">
                      <el-tag type="success" @click="changeShow('xm45')">
                        <div class="leftSum id45">7.1采购</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm7_1Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_1Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_1Count - xm7_1Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm7_1hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm7_1jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_1buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm7_1bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_1weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm45" class="xiangmu">
                        <div v-if="id46" ref="id46" class="id46">
                          <el-tag
                            v-if="id46"
                            type="danger"
                            @click="changeShow('xm46')"
                          >
                            <div class="leftSum id46">
                              7.1.1制定并实施采购管理制度
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_1_1Panding"
                                @change="
                                  setMealSelect($event, 'xm7_1_1P', 'id46')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm46" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否制定并实施采购管理制度？
                                <span class="xm7_1_1Panding_1">
                                  <el-radio-group v-model="xm7_1_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                制度名称
                                <el-input
                                  v-model="xm7_1_1Panding_2"
                                  class="xm7_1_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm7_1_1Panding_3"
                                  class="xm7_1_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                文件中是否包含以下内容
                                <span class="xm7_1_1Panding_4">
                                  <el-checkbox-group v-model="xm7_1_1Panding_4">
                                    <el-checkbox label="01">
                                      供方选择与评价
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      验收（证）要求与方法
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      采购品的入库管理
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      不合格品的管理与控制
                                    </el-checkbox>
                                    <el-checkbox label="05">
                                      应持有的相关配套证件
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_1_1Panding_5"
                                  class="xm7_1_1Panding_5"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id47" ref="id47" class="id47">
                          <el-tag
                            v-if="id47"
                            type="danger"
                            @click="changeShow('xm47')"
                          >
                            <div class="leftSum id47">
                              7.1.2合格供方名录质量档案
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_1_2Panding"
                                @change="
                                  setMealSelect($event, 'xm7_1_2P', 'id47')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm47" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否建立合格供方名录、质量档案、采购控制清单？
                                <span class="xm7_1_2Panding_1">
                                  <el-radio-group v-model="xm7_1_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                合格供方名录是否包含供方名称、采购物资名称、联系人等信息,且经过批准？
                                <span class="xm7_1_2Panding_2">
                                  <el-radio-group v-model="xm7_1_2Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                合格供方名录中供方是否齐全,是否与实际相符？
                                <span class="xm7_1_2Panding_3">
                                  <el-radio-group v-model="xm7_1_2Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                不合格品控制记录保存时间是否不低于5年？
                                <span class="xm7_1_2Panding_4">
                                  <el-radio-group v-model="xm7_1_2Panding_4">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                质量档案是否包含供方营业执照、资质等？
                                <span class="xm7_1_2Panding_5">
                                  <el-radio-group v-model="xm7_1_2Panding_5">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                采购控制清单是否包含了安标备案的主要零（元）部件、重要原材料明细表中所包含的零（元）部件、原材料？
                                <span>
                                  <el-radio-group v-model="radio">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">/不适用</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                采购控制清单是否明确了质量要求？
                                <span class="xm7_1_2Panding_6">
                                  <el-radio-group v-model="xm7_1_2Panding_6">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">/不适用</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                对关键零（元）部件、重要原材料供方是否每年至少进行1次供方评价？
                                <span class="xm7_1_2Panding_7">
                                  <el-radio-group v-model="xm7_1_2Panding_7">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">/不适用</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  供方1名称:
                                  <el-input
                                    v-model="xm7_1_2Panding_8"
                                    class="xm7_1_2Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  评价日期
                                  <el-date-picker
                                    v-model="xm7_1_2Panding_9"
                                    type="date"
                                    class="xm7_1_2Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-date-picker>
                                </p>
                                <p>
                                  供方2名称:
                                  <el-input
                                    v-model="xm7_1_2Panding_10"
                                    class="xm7_1_2Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  评价日期
                                  <el-date-picker
                                    v-model="xm7_1_2Panding_11"
                                    type="date"
                                    class="xm7_1_2Panding_11"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-date-picker>
                                </p>
                                <p>
                                  供方3名称:
                                  <el-input
                                    v-model="xm7_1_2Panding_12"
                                    class="xm7_1_2Panding_12"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  评价日期
                                  <el-date-picker
                                    v-model="xm7_1_2Panding_13"
                                    type="date"
                                    class="xm7_1_2Panding_13"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-date-picker>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_1_2Panding_14"
                                  class="xm7_1_2Panding_14"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id48" ref="id48" class="id48">
                          <el-tag
                            v-if="id48"
                            type="danger"
                            @click="changeShow('xm48')"
                          >
                            <div class="leftSum id48">7.1.3供方合格评定</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_1_3Panding"
                                @change="
                                  setMealSelect($event, 'xm7_1_3P', 'id48')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm48" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否从经过评价证明有能力确保符合所有规定要求的供方购买产品？
                                <span class="xm7_1_3Panding_1">
                                  <el-radio-group v-model="xm7_1_3Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_1_3Panding_2"
                                  class="xm7_1_3Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id49" ref="id49" class="id49">
                          <el-tag
                            v-if="id49"
                            type="danger"
                            @click="changeShow('xm49')"
                          >
                            <div class="leftSum id49">
                              7.1.4采购合同或协议明确要求
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_1_4Panding"
                                @change="
                                  setMealSelect($event, 'xm7_1_4P', 'id49')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm49" class="xiangmu">
                            <div class="neirong">
                              <p>
                                采购合同或协议中是否明确相关技术要求、验收标准？
                                <span class="xm7_1_4Panding_1">
                                  <el-radio-group v-model="xm7_1_4Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  合同1零件名称:
                                  <el-input
                                    v-model="xm7_1_4Panding_2"
                                    class="xm7_1_4Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  合同编号或日期
                                  <el-input
                                    v-model="xm7_1_4Panding_3"
                                    class="xm7_1_4Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  供方1名称:
                                  <el-input
                                    v-model="xm7_1_4Panding_4"
                                    class="xm7_1_4Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                                <p>
                                  合同2零件名称:
                                  <el-input
                                    v-model="xm7_1_4Panding_5"
                                    class="xm7_1_4Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  合同编号或日期
                                  <el-input
                                    v-model="xm7_1_4Panding_6"
                                    class="xm7_1_4Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  供方2名称:
                                  <el-input
                                    v-model="xm7_1_4Panding_7"
                                    class="xm7_1_4Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                                <p>
                                  合同3零件名称:
                                  <el-input
                                    v-model="xm7_1_4Panding_8"
                                    class="xm7_1_4Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  合同编号或日期
                                  <el-input
                                    v-model="xm7_1_4Panding_9"
                                    class="xm7_1_4Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  供方3名称:
                                  <el-input
                                    v-model="xm7_1_4Panding_10"
                                    class="xm7_1_4Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_1_4Panding_11"
                                  class="xm7_1_4Panding_11"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id50" ref="id50" class="id50">
                          <el-tag
                            v-if="id50"
                            type="danger"
                            @click="changeShow('xm50')"
                          >
                            <div class="leftSum id50">
                              7.1.5采购品检验合格证
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_1_5Panding"
                                @change="
                                  setMealSelect($event, 'xm7_1_5P', 'id50')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm50" class="xiangmu">
                            <div class="neirong">
                              <p>
                                采购品是否有检验合格的证明
                                <span class="xm7_1_5Panding_1">
                                  <el-radio-group v-model="xm7_1_5Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                属安标受控的主要零（元）部件和重要原材料,是否满足安标备案技术文件中的要求？
                                <span class="xm7_1_5Panding_2">
                                  <el-radio-group v-model="xm7_1_5Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  零件（原材料）1名称：:
                                  <el-input
                                    v-model="xm7_1_5Panding_3"
                                    class="xm7_1_5Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  出厂日期
                                  <el-input
                                    v-model="xm7_1_5Panding_4"
                                    class="xm7_1_5Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>

                                <p>
                                  零件（原材料）2名称：
                                  <el-input
                                    v-model="xm7_1_5Panding_5"
                                    class="xm7_1_5Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  出厂日期
                                  <el-input
                                    v-model="xm7_1_5Panding_6"
                                    class="xm7_1_5Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  零件（原材料）3名称： :
                                  <el-input
                                    v-model="xm7_1_5Panding_7"
                                    class="xm7_1_5Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  出厂日期
                                  <el-input
                                    v-model="xm7_1_5Panding_8"
                                    class="xm7_1_5Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_1_5Panding_9"
                                  class="xm7_1_5Panding_9"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                产品一致性核查情况见附件5
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id51" ref="id51" class="id51">
                          <el-tag
                            v-if="id51"
                            type="danger"
                            @click="changeShow('xm51')"
                          >
                            <div class="leftSum id51">
                              7.1.6采购件一致性控制措施
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_1_6Panding"
                                @change="
                                  setMealSelect($event, 'xm7_1_6P', 'id51')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm51" class="xiangmu">
                            <div class="neirong">
                              <p>
                                当从经销商、贸易商采购主要零（元）部件和原材料时,是否采取适当措施以确保采购件满足安标管理的一致性、可追溯性要求？
                                <span class="xm7_1_6Panding_1">
                                  <el-radio-group v-model="xm7_1_6Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  零件（原材料）名称:
                                  <el-input
                                    v-model="xm7_1_6Panding_2"
                                    class="xm7_1_6Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>

                                <p>
                                  经销商名称
                                  <el-input
                                    v-model="xm7_1_6Panding_3"
                                    class="xm7_1_6Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  生产厂家名称 :
                                  <el-input
                                    v-model="xm7_1_6Panding_4"
                                    class="xm7_1_6Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>
                                </p>
                                <p>
                                  可追溯性措施:
                                  <el-input
                                    v-model="xm7_1_6Panding_5"
                                    class="xm7_1_6Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_1_6Panding_6"
                                  class="xm7_1_6Panding_6"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id52" ref="id52" class="id52">
                      <el-tag type="success" @click="changeShow('xm52')">
                        <div class="leftSum id52">7.2外协</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm7_2Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_2Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_2Count - xm7_2Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm7_2hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm7_2jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_2buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm7_2bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm7_2weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm52" class="xiangmu">
                        <div v-if="id53" ref="id53" class="id53">
                          <el-tag
                            v-if="id53"
                            type="danger"
                            @click="changeShow('xm53')"
                          >
                            <div class="leftSum id53">7.2.1外协管理制度</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_2_1Panding"
                                @change="
                                  setMealSelect($event, 'xm7_2_1P', 'id53')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm53" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否制定并实施外协管理制度？
                                <span class="xm7_2_1Panding_1">
                                  <el-radio-group v-model="xm7_2_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                制度名称 :
                                <el-input
                                  v-model="xm7_2_1Panding_2"
                                  class="xm7_2_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm7_2_1Panding_3"
                                  class="xm7_2_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                文件中是否包含以下内容
                                <span class="xm7_2_1Panding_4">
                                  <el-checkbox-group v-model="xm7_2_1Panding_4">
                                    <el-checkbox label="01">
                                      外协方选择与评价
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      验收（证）要求与方法
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      外协件的入库管理
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      不合格品的管理与控制
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_2_1Panding_5"
                                  class="xm7_2_1Panding_5"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id54" ref="id54" class="id54">
                          <el-tag
                            v-if="id54"
                            type="danger"
                            @click="changeShow('xm54')"
                          >
                            <div class="leftSum id54">
                              7.2.2合格外协方名录质量档案
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_2_2Panding"
                                @change="
                                  setMealSelect($event, 'xm7_2_2P', 'id54')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm54" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否建立合格外协方名录、质量档案、外协控制清单？
                                <span class="xm7_2_2Panding_1">
                                  <el-radio-group v-model="xm7_2_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                合格外协方名录中是否包含外协方名称、外协的产品或工序、联系人等信息,且经过批准？
                                <span class="xm7_2_2Panding_2">
                                  <el-radio-group v-model="xm7_2_2Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                合格外协方名录中外协方是否齐全,是否与实际相符？
                                <span class="xm7_2_2Panding_3">
                                  <el-radio-group v-model="xm7_2_2Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                质量档案是否包含供方营业执照、资质等？
                                <span class="xm7_2_2Panding_4">
                                  <el-radio-group v-model="xm7_2_2Panding_4">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                外协控制清单是否包含了安标备案的主要零（元）部件、重要原材料明细表中所包含的零（元）部件、原材料等？
                                <span class="xm7_2_2Panding_5">
                                  <el-radio-group v-model="xm7_2_2Panding_5">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                外协控制清单是否明确了技术要求？
                                <span class="xm7_2_2Panding_6">
                                  <el-radio-group v-model="xm7_2_2Panding_6">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>

                              <p>
                                对关键零（元）部件、重要原材料外协方是否每年至少进行1次外协方评价？
                                <span class="xm7_2_2Panding_7">
                                  <el-radio-group v-model="xm7_2_2Panding_7">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  外协方1名称:
                                  <el-input
                                    v-model="xm7_2_2Panding_8"
                                    class="xm7_2_2Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  评价日期
                                  <el-date-picker
                                    v-model="xm7_2_2Panding_9"
                                    type="date"
                                    class="xm7_2_2Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-date-picker>
                                </p>
                                <p>
                                  外协方2名称:
                                  <el-input
                                    v-model="xm7_2_2Panding_10"
                                    class="xm7_2_2Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  评价日期
                                  <el-date-picker
                                    v-model="xm7_2_2Panding_11"
                                    type="date"
                                    class="xm7_2_2Panding_11"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-date-picker>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_2_2Panding_12"
                                  class="xm7_2_2Panding_12"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id55" ref="id55" class="id55">
                          <el-tag
                            v-if="id55"
                            type="danger"
                            @click="changeShow('xm55')"
                          >
                            <div class="leftSum id55">7.2.3外协方合格评定</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_2_3Panding"
                                @change="
                                  setMealSelect($event, 'xm7_2_3P', 'id55')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm55" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否从经过评价证明有能力确保符合所有规定要求的外协方购买产品？
                                <span class="xm7_2_3Panding_1">
                                  <el-radio-group v-model="xm7_2_3Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_2_3Panding_2"
                                  class="xm7_2_3Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id56" ref="id56" class="id56">
                          <el-tag
                            v-if="id56"
                            type="danger"
                            @click="changeShow('xm56')"
                          >
                            <div class="leftSum id56">
                              7.2.4外协合同或协议明确要求
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_2_4Panding"
                                @change="
                                  setMealSelect($event, 'xm7_2_4P', 'id56')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm56" class="xiangmu">
                            <div class="neirong">
                              <p>
                                外协合同或协议中是否明确相关技术要求、验收标准？
                                <span class="xm7_2_4Panding_1">
                                  <el-radio-group v-model="xm7_2_4Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  合同1零件名称：:
                                  <el-input
                                    v-model="xm7_2_4Panding_2"
                                    class="xm7_2_4Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  合同编号或日期
                                  <el-input
                                    v-model="xm7_2_4Panding_3"
                                    class="xm7_2_4Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  供方:
                                  <el-input
                                    v-model="xm7_2_4Panding_4"
                                    class="xm7_2_4Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                                <p>
                                  合同2零件名称:
                                  <el-input
                                    v-model="xm7_2_4Panding_5"
                                    class="xm7_2_4Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  合同编号或日期
                                  <el-input
                                    v-model="xm7_2_4Panding_6"
                                    class="xm7_2_4Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  供方:
                                  <el-input
                                    v-model="xm7_2_4Panding_7"
                                    class="xm7_2_4Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                                <p>
                                  合同3零件名称:
                                  <el-input
                                    v-model="xm7_2_4Panding_8"
                                    class="xm7_2_4Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  合同编号或日期
                                  <el-input
                                    v-model="xm7_2_4Panding_9"
                                    class="xm7_2_4Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  供方:
                                  <el-input
                                    v-model="xm7_2_4Panding_10"
                                    class="xm7_2_4Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 80%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_2_4Panding_11"
                                  class="xm7_2_4Panding_11"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id57" ref="id57" class="id57">
                          <el-tag
                            v-if="id57"
                            type="danger"
                            @click="changeShow('xm57')"
                          >
                            <div class="leftSum id57">
                              7.2.5外协件加工有效性控制
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_2_5Panding"
                                @change="
                                  setMealSelect($event, 'xm7_2_5P', 'id57')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm57" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否对外协件加工所需的图样、技术要求、工装模具（必要时）、加工工艺（必要时）等进行有效控制,以确保外协件持续满足规定要求？
                                <span class="xm7_2_5Panding_1">
                                  <el-radio-group v-model="xm7_2_5Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                控制措施
                                <el-input
                                  v-model="xm7_2_5Panding_2"
                                  class="xm7_2_5Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_2_5Panding_3"
                                  class="xm7_2_5Panding_3"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id58" ref="id58" class="id58">
                          <el-tag
                            v-if="id58"
                            type="danger"
                            @click="changeShow('xm58')"
                          >
                            <div class="leftSum id58">
                              7.2.6外协件检验合格证明
                            </div>

                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_2_6Panding"
                                @change="
                                  setMealSelect($event, 'xm7_2_6P', 'id58')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm58" class="xiangmu">
                            <div class="neirong">
                              <p>
                                外协件是否有检验合格的证明
                                <span class="xm7_2_6Panding_1">
                                  <el-radio-group v-model="xm7_2_6Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                属安标受控的主要零（元）部件和重要原材料,是否满足安标备案技术文件中的要求？
                                <span class="xm7_2_6Panding_2">
                                  <el-radio-group v-model="xm7_2_6Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  零件（原材料）1名称:
                                  <el-input
                                    v-model="xm7_2_6Panding_3"
                                    class="xm7_2_6Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  出厂日期
                                  <el-input
                                    v-model="xm7_2_6Panding_4"
                                    class="xm7_2_6Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>

                                <p>
                                  零件（原材料）2名称:
                                  <el-input
                                    v-model="xm7_2_6Panding_5"
                                    class="xm7_2_6Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  出厂日期
                                  <el-input
                                    v-model="xm7_2_6Panding_6"
                                    class="xm7_2_6Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  零件（原材料）3名称:
                                  <el-input
                                    v-model="xm7_2_6Panding_7"
                                    class="xm7_2_6Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  出厂日期
                                  <el-input
                                    v-model="xm7_2_6Panding_8"
                                    class="xm7_2_6Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_2_6Panding_9"
                                  class="xm7_2_6Panding_9"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                产品一致性核查情况见附件5。
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id59" ref="id59" class="id59">
                          <el-tag
                            v-if="id59"
                            type="danger"
                            @click="changeShow('xm59')"
                          >
                            <div class="leftSum id59">7.2.7外协件检验方式</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm7_2_7Panding"
                                @change="
                                  setMealSelect($event, 'xm7_2_7P', 'id59')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm59" class="xiangmu">
                            <div class="neirong">
                              <p>
                                文件中是否明确了外协件在外协厂监督检验还是入厂抽检
                                <span class="xm7_2_7Panding_1">
                                  <el-radio-group v-model="xm7_2_7Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                文件名称:
                                <el-input
                                  v-model="xm7_2_7Panding_2"
                                  class="xm7_2_7Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm7_2_7Panding_3"
                                  class="xm7_2_7Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm7_2_7Panding_4"
                                  class="xm7_2_7Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id60" name="tab8" label="8生产控制">
            <!-- 8生产控制-->

            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id60" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm60')">
                    <div class="leftSum id60">
                      <vab-icon
                        :icon="['fas', 'balance-scale-left']"
                        style="color: #ff9c6e"
                      ></vab-icon>
                      8生产控制
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_8JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm8Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm8Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm8Count - xm8Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm8hege == '0' ? 'info' : 'success'">
                          {{ xm8hege }}合格
                        </el-tag>

                        <el-tag :type="xm8jibenhege == '0' ? 'info' : 'danger'">
                          {{ xm8jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm8buhege == '0' ? 'info' : 'danger'">
                          {{ xm8buhege }}不合格
                        </el-tag>

                        <el-tag type="info">{{ xm8bushiyong }}不适用</el-tag>

                        <el-tag :type="xm8weipan == '0' ? 'info' : 'danger'">
                          {{ xm8weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm60" class="xiangmu">
                    <div v-if="id61" ref="id61" class="id61">
                      <el-tag type="success" @click="changeShow('xm61')">
                        <div class="leftSum id61">8.1生产能力</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm8_1Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_1Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_1Count - xm8_1Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm8_1hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm8_1jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_1buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm8_1bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_1weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm61" class="xiangmu">
                        <div v-if="id62" ref="id62" class="id62">
                          <el-tag
                            v-if="id62"
                            type="danger"
                            @click="changeShow('xm62')"
                          >
                            <div class="leftSum id62">
                              <i class="el-icon-warning"></i>

                              8.1.1产品总装调试能力并自行组装生产
                            </div>

                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_1_1Panding"
                                @change="
                                  setMealSelect($event, 'xm8_1_1P', 'id62')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in twoOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm62" class="xiangmu">
                            <div class="neirong">
                              <p>
                                <span class="fouju">
                                  ★
                                  通过现场核查设备、设施及人员配备、生产记录等,是否具备产品的总装、调试能力,并自行组装生产？
                                </span>
                                <span class="xm8_1_1Panding_1">
                                  <el-radio-group v-model="xm8_1_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                抽查
                                <el-input
                                  v-model="xm8_1_1Panding_2"
                                  class="xm8_1_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 200px"
                                ></el-input>
                                （产品名称）成品台账,上次评审日期至今成品数量
                                <el-input
                                  v-model="xm8_1_1Panding_3"
                                  class="xm8_1_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 80px"
                                ></el-input>
                                台（套）。抽查了生产日期：
                                <el-input
                                  v-model="xm8_1_1Panding_4"
                                  class="xm8_1_1Panding_4"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>

                                <el-input
                                  v-model="xm8_1_1Panding_5"
                                  class="xm8_1_1Panding_5"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>

                                <el-input
                                  v-model="xm8_1_1Panding_6"
                                  class="xm8_1_1Panding_6"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                ,出厂编号（批次）：
                                <el-input
                                  v-model="xm8_1_1Panding_7"
                                  class="xm8_1_1Panding_7"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>

                                <el-input
                                  v-model="xm8_1_1Panding_8"
                                  class="xm8_1_1Panding_8"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>

                                <el-input
                                  v-model="xm8_1_1Panding_9"
                                  class="xm8_1_1Panding_9"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                的产品总装、调试记录。关于采购、检验、一致性的条款中的抽查记录与此对应。
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_1_1Panding_10"
                                  class="xm8_1_1Panding_10"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id63" ref="id63" class="id63">
                          <el-tag
                            v-if="id63"
                            type="danger"
                            @click="changeShow('xm63')"
                          >
                            <div class="leftSum id63">
                              <i class="el-icon-warning"></i>

                              8.1.2生产设备的加工能力精度生产工艺
                            </div>

                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_1_2Panding"
                                @change="
                                  setMealSelect($event, 'xm8_1_2P', 'id63')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions0"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm63" class="xiangmu">
                            <div class="neirong">
                              <p>
                                <span class="fouju">
                                  ★
                                  自行生产产品零（元）部件、原材料的,生产设备的加工能力、精度、生产工艺是否满足产品技术要求？
                                </span>
                                <span class="xm8_1_2Panding_1">
                                  <el-radio-group v-model="xm8_1_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                自行生产零（元）部件、原材料名称:
                                <el-input
                                  v-model="xm8_1_2Panding_2"
                                  class="xm8_1_2Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                              </p>
                              <p>
                                抽查
                                <el-input
                                  v-model="xm8_1_2Panding_3"
                                  class="xm8_1_2Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                （产品名称）成品台账,上次评审日期至今成品数量
                                <el-input
                                  v-model="xm8_1_2Panding_4"
                                  class="xm8_1_2Panding_4"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 80px"
                                ></el-input>
                                台（套）。抽查了生产日期：
                                <el-input
                                  v-model="xm8_1_2Panding_5"
                                  class="xm8_1_2Panding_5"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>

                                <el-input
                                  v-model="xm8_1_2Panding_6"
                                  class="xm8_1_2Panding_6"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>

                                <el-input
                                  v-model="xm8_1_2Panding_7"
                                  class="xm8_1_2Panding_7"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>

                                等自行生产零（元）部件、原材料的加工、检验记录。
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_1_2Panding_8"
                                  class="xm8_1_2Panding_8"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                主要生产设备一览表见附表2,生产设备及生产现场应拍照,保存在文件夹“生产现场及设备”。
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id64" ref="id64" class="id64">
                          <el-tag
                            v-if="id64"
                            type="danger"
                            @click="changeShow('xm64')"
                          >
                            <div class="leftSum id64">
                              8.1.3工艺装备及工位器具其配置和使用
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_1_3Panding"
                                @change="
                                  setMealSelect($event, 'xm8_1_3P', 'id64')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm64" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否有满足生产要求的工艺装备及工位器具,其配置和使用是否合理、可行？
                                <span class="xm8_1_3Panding_1">
                                  <el-radio-group v-model="xm8_1_3Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                是否有工艺装备台账？
                                <span class="xm8_1_3Panding_2">
                                  <el-radio-group v-model="xm8_1_3Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                是否有工位器具台账？
                                <span class="xm8_1_3Panding_3">
                                  <el-radio-group v-model="xm8_1_3Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_1_3Panding_4"
                                  class="xm8_1_3Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id65" ref="id65" class="id65">
                      <el-tag type="success" @click="changeShow('xm65')">
                        <div class="leftSum id65">8.2过程控制</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm8_2Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_2Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_2Count - xm8_2Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm8_2hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm8_2jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_2buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm8_2bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm8_2weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm65" class="xiangmu">
                        <div v-if="id66" ref="id66" class="id66">
                          <el-tag
                            v-if="id66"
                            type="danger"
                            @click="changeShow('xm66')"
                          >
                            <div class="leftSum id66">
                              8.2.1设备工艺装备工位器具管理制度
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_2_1Panding"
                                @change="
                                  setMealSelect($event, 'xm8_2_1P', 'id66')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm66" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否建立设备、工艺装备、工位器具管理制度？
                                <span class="xm8_2_1Panding_1">
                                  <el-radio-group v-model="xm8_2_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                生产设备管理文件名称:
                                <el-input
                                  v-model="xm8_2_1Panding_2"
                                  class="xm8_2_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm8_2_1Panding_3"
                                  class="xm8_2_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                工艺装备管理文件名称:
                                <el-input
                                  v-model="xm8_2_1Panding_4"
                                  class="xm8_2_1Panding_4"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm8_2_1Panding_5"
                                  class="xm8_2_1Panding_5"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                工位器具管理文件名称:
                                <el-input
                                  v-model="xm8_2_1Panding_6"
                                  class="xm8_2_1Panding_6"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>

                                编号
                                <el-input
                                  v-model="xm8_2_1Panding_7"
                                  class="xm8_2_1Panding_7"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 20%"
                                ></el-input>
                              </p>
                              <p>
                                是否包括以下内容:
                                <span class="xm8_2_1Panding_8">
                                  <el-checkbox-group v-model="xm8_2_1Panding_8">
                                    <el-checkbox label="01">
                                      台账管理制度
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      设备日常维护保养制度
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      工艺装备验收验证制度等
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>

                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_2_1Panding_9"
                                  class="xm8_2_1Panding_9"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id67" ref="id67" class="id67">
                          <el-tag
                            v-if="id67"
                            type="danger"
                            @click="changeShow('xm67')"
                          >
                            <div class="leftSum id67">
                              8.2.2重要设备操作规程
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_2_2Panding"
                                @change="
                                  setMealSelect($event, 'xm8_2_2P', 'id67')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm67" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否有重要设备操作规程,操作规程的内容是否完整、具有可操作性？
                                <span class="xm8_2_2Panding_1">
                                  <el-radio-group v-model="xm8_2_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                操作人员在设备现场是否能获取、查阅规程？
                                <span class="xm8_2_2Panding_2">
                                  <el-radio-group v-model="xm8_2_2Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                操作规程1名称
                                <el-input
                                  v-model="xm8_2_2Panding_3"
                                  class="xm8_2_2Panding_3"
                                  clearable
                                  placeholder="操作规程1名称"
                                  style="width: 80%"
                                ></el-input>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_2_2Panding_4"
                                  class="xm8_2_2Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id68" ref="id68" class="id68">
                          <el-tag
                            v-if="id68"
                            type="danger"
                            @click="changeShow('xm68')"
                          >
                            <div class="leftSum id68">
                              8.2.3工装验证设备维修保养记录
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_2_3Panding"
                                @change="
                                  setMealSelect($event, 'xm8_2_3P', 'id68')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm68" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否按照计划要求进行工装验证、设备维修保养,并保存相关记录？
                                <span class="xm8_2_3Panding_1">
                                  <el-radio-group v-model="xm8_2_3Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <el-card>
                                <p>
                                  工装验证记录1名称
                                  <el-input
                                    v-model="xm8_2_3Panding_2"
                                    class="xm8_2_3Panding_2"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  日期
                                  <el-input
                                    v-model="xm8_2_3Panding_3"
                                    class="xm8_2_3Panding_3"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>

                                <p>
                                  工装验证记录2名称
                                  <el-input
                                    v-model="xm8_2_3Panding_4"
                                    class="xm8_2_3Panding_4"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  日期
                                  <el-input
                                    v-model="xm8_2_3Panding_5"
                                    class="xm8_2_3Panding_5"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  设备维修记录1名称
                                  <el-input
                                    v-model="xm8_2_3Panding_6"
                                    class="xm8_2_3Panding_6"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  日期
                                  <el-input
                                    v-model="xm8_2_3Panding_7"
                                    class="xm8_2_3Panding_7"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  设备维修记录2名称
                                  <el-input
                                    v-model="xm8_2_3Panding_8"
                                    class="xm8_2_3Panding_8"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  日期
                                  <el-input
                                    v-model="xm8_2_3Panding_9"
                                    class="xm8_2_3Panding_9"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  设备保养记录1名称
                                  <el-input
                                    v-model="xm8_2_3Panding_10"
                                    class="xm8_2_3Panding_10"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  日期
                                  <el-input
                                    v-model="xm8_2_3Panding_11"
                                    class="xm8_2_3Panding_11"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                                <p>
                                  设备保养记录2名称
                                  <el-input
                                    v-model="xm8_2_3Panding_12"
                                    class="xm8_2_3Panding_12"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 40%"
                                  ></el-input>

                                  日期
                                  <el-input
                                    v-model="xm8_2_3Panding_13"
                                    class="xm8_2_3Panding_13"
                                    clearable
                                    placeholder="请输入内容"
                                    style="width: 20%"
                                  ></el-input>
                                </p>
                              </el-card>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_2_3Panding_14"
                                  class="xm8_2_3Panding_14"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id69" ref="id69" class="id69">
                          <el-tag
                            v-if="id69"
                            type="danger"
                            @click="changeShow('xm69')"
                          >
                            <div class="leftSum id69">
                              8.2.4工艺文件是否完整正确
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_2_4Panding"
                                @change="
                                  setMealSelect($event, 'xm8_2_4P', 'id69')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm69" class="xiangmu">
                            <div class="neirong">
                              <p>
                                工艺文件是否完整、正确？
                                <span class="xm8_2_4Panding_1">
                                  <el-radio-group v-model="xm8_2_4Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                适用时,工艺文件包括：
                                <span class="xm8_2_4Panding_2">
                                  <el-checkbox-group v-model="xm8_2_4Panding_2">
                                    <el-checkbox label="01">
                                      工艺路线明细表（工艺流程图）
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      工艺过程卡
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      装配工艺卡
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      零件加工工艺卡
                                    </el-checkbox>
                                    <el-checkbox label="05">检验卡</el-checkbox>
                                    <el-checkbox label="06">
                                      外购（协）件明细
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p>
                                工艺路线明细表（工艺流程图）是否明晰、明确关键工序并按其执行？
                                <span class="xm8_2_4Panding_3">
                                  <el-radio-group v-model="xm8_2_4Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                抽查
                                <el-input
                                  v-model="xm8_2_4Panding_4"
                                  class="xm8_2_4Panding_4"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                （产品名称）的
                                <el-input
                                  v-model="xm8_2_4Panding_5"
                                  class="xm8_2_4Panding_5"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                （关键工序名称）,现场人员操作是否与工艺文件要求一致？
                                <span class="xm8_2_4Panding_6">
                                  <el-radio-group v-model="xm8_2_4Panding_6">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_2_4Panding_7"
                                  class="xm8_2_4Panding_7"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                现场考核工序的人员操作应拍照,保存在文件夹“生产现场及设备”
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id70" ref="id70" class="id70">
                          <el-tag
                            v-if="id70"
                            type="danger"
                            @click="changeShow('xm70')"
                          >
                            <div class="leftSum id70">
                              8.2.5关键工序控制程序或作业指导书
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_2_5Panding"
                                @change="
                                  setMealSelect($event, 'xm8_2_5P', 'id70')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm70" class="xiangmu">
                            <div class="neirong">
                              <p>
                                对影响产品安全性能、一致性的关键工序,是否制定工序控制程序或作业指导书？
                                <span class="xm8_2_5Panding_1">
                                  <el-radio-group v-model="xm8_2_5Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                抽查
                                <el-input
                                  v-model="xm8_2_5Panding_2"
                                  class="xm8_2_5Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                （作业指导书名称）,现场人员操作是否与其要求一致？
                                <span class="xm8_2_5Panding_3">
                                  <el-radio-group v-model="xm8_2_5Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_2_5Panding_4"
                                  class="xm8_2_5Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id71" ref="id71" class="id71">
                          <el-tag
                            v-if="id71"
                            type="danger"
                            @click="changeShow('xm71')"
                          >
                            <div class="leftSum id71">
                              8.2.6生产过程对环境条件是否有要求
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm8_2_6Panding"
                                @change="
                                  setMealSelect($event, 'xm8_2_6P', 'id71')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>

                          <div ref="xm71" class="xiangmu">
                            <div class="neirong">
                              <p>
                                产品生产过程对环境条件是否有要求？
                                <span class="xm8_2_6Panding_1">
                                  <el-radio-group v-model="xm8_2_6Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm8_2_6Panding_2"
                                  class="xm8_2_6Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id72" name="tab9" label="9检验和测试控制">
            <!-- 9检验和测试控制-->

            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id72" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm72')">
                    <div class="leftSum id72">
                      <vab-icon
                        :icon="['fas', 'gift']"
                        style="color: #ff85c0"
                      ></vab-icon>
                      9检验和测试控制
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_9JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm9Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm9Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm9Count - xm9Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm9hege == '0' ? 'info' : 'success'">
                          {{ xm9hege }}合格
                        </el-tag>

                        <el-tag :type="xm9jibenhege == '0' ? 'info' : 'danger'">
                          {{ xm9jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm9buhege == '0' ? 'info' : 'danger'">
                          {{ xm9buhege }}不合格
                        </el-tag>

                        <el-tag type="info">{{ xm9bushiyong }}不适用</el-tag>

                        <el-tag :type="xm9weipan == '0' ? 'info' : 'danger'">
                          {{ xm9weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm72" class="xiangmu">
                    <div v-if="id73" ref="id73" class="id73">
                      <el-tag type="success" @click="changeShow('xm73')">
                        <div class="leftSum id73">9.1检验控制</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm9_1Panding"
                            @change="setMealSelect($event, 'xm9_1P', 'id73')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm73" class="xiangmu">
                        <div class="neirong">
                          <p>
                            是否建立并实施检验和测试管理制度？
                            <span class="xm9_1Panding_1">
                              <el-radio-group v-model="xm9_1Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            文件名称
                            <el-input
                              v-model="xm9_1Panding_2"
                              class="xm9_1Panding_2"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                            文件名称
                            <el-input
                              v-model="xm9_1Panding_3"
                              class="xm9_1Panding_3"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p>
                            文件中是否包含以下内容
                            <span class="xm9_1Panding_4">
                              <el-checkbox-group v-model="xm9_1Panding_4">
                                <el-checkbox label="01">
                                  对采购或外协的零（元）部件（原材料）的入厂检验进行控制
                                </el-checkbox>
                                <el-checkbox label="02">
                                  对产品的过程检验进行控制
                                </el-checkbox>
                                <el-checkbox label="03">
                                  对产品的出厂检验进行控制
                                </el-checkbox>
                                <el-checkbox label="04">
                                  保证未经检验的及检验不合格的产品或零部件不能进入后续环节
                                </el-checkbox>
                              </el-checkbox-group>
                            </span>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm9_1Panding_5"
                              class="xm9_1Panding_5"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id74" ref="id74" class="id74">
                      <el-tag type="success" @click="changeShow('xm74')">
                        <div class="leftSum id74">9.2检验能力</div>
                        <div class="secondDanxiang">
                          <div>
                            <el-tag type="danger">
                              {{ xm9_2Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_2Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_2Count - xm9_2Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm9_2hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm9_2jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_2buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm9_2bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_2weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm74" class="xiangmu">
                        <div v-if="id75" ref="id75" class="id75">
                          <el-tag
                            v-if="id75"
                            type="danger"
                            @click="changeShow('xm75')"
                          >
                            <div class="leftSum id75">
                              9.2.1检验环境设备的精度和能力
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_2_1Panding"
                                @change="
                                  setMealSelect($event, 'xm9_2_1P', 'id75')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm75" class="xiangmu">
                            <div class="neirong">
                              <p>
                                产品检验环境、检测检验设备的精度和能力等是否符合相关标准要求？
                                <span class="xm9_2_1Panding_1">
                                  <el-radio-group v-model="xm9_2_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_2_1Panding_2"
                                  class="xm9_2_1Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                主要检验环境监控设备、产品检测检验设备、设施信息一览表见附表3,主要检验环境监控设备、产品检测检验设备、设施应拍照,保存在文件夹“检验设备及过程”。
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id76" ref="id76" class="id76">
                          <el-tag
                            v-if="id76"
                            type="danger"
                            @click="changeShow('xm76')"
                          >
                            <div class="leftSum id76">
                              9.2.2产品批量生产时的检验要求
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_2_2Panding"
                                @change="
                                  setMealSelect($event, 'xm9_2_2P', 'id76')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm76" class="xiangmu">
                            <div class="neirong">
                              <p>
                                检验能力是否满足产品批量生产时的检验要求？
                                <span class="xm9_2_2Panding_1">
                                  <el-radio-group v-model="xm9_2_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>

                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_2_2Panding_2"
                                  class="xm9_2_2Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id77" ref="id77" class="id77">
                      <el-tag type="success" @click="changeShow('xm77')">
                        <div class="leftSum id77">9.3操作规程</div>

                        <div class="secondDanxiang">
                          <div>
                            <el-tag type="danger">
                              {{ xm9_3Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_3Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_3Count - xm9_3Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm9_3hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm9_3jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_3buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm9_3bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_3weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm77" class="xiangmu">
                        <div v-if="id78" ref="id78" class="id78">
                          <el-tag
                            v-if="id78"
                            type="danger"
                            @click="changeShow('xm78')"
                          >
                            <div class="leftSum id78">
                              9.3.1检测检验设备的操作规程
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_3_1Panding"
                                @change="
                                  setMealSelect($event, 'xm9_3_1P', 'id78')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm78" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否有重要检测检验设备的操作规程
                                <span class="xm9_3_1Panding_1">
                                  <el-radio-group v-model="xm9_3_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                抽查了
                                <el-input
                                  v-model="xm9_3_1Panding_2"
                                  class="xm9_3_1Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                重要检测检验设备操作规程。
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_3_1Panding_3"
                                  class="xm9_3_1Panding_3"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id79" ref="id79" class="id79">
                          <el-tag
                            v-if="id79"
                            type="danger"
                            @click="changeShow('xm79')"
                          >
                            <div class="leftSum id79">
                              9.3.2操作规程方便获取查阅
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_3_2Panding"
                                @change="
                                  setMealSelect($event, 'xm9_3_2P', 'id79')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm79" class="xiangmu">
                            <div class="neirong">
                              <p>
                                重要检测检验设备的操作规程是否在设备使用现场方便操作者获取、查阅？
                                <span class="xm9_3_2Panding_1">
                                  <el-radio-group v-model="xm9_3_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_3_2Panding_2"
                                  class="xm9_3_2Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id80" ref="id80" class="id80">
                      <el-tag type="success" @click="changeShow('xm80')">
                        <div class="leftSum id80">9.4检验规程</div>
                        <div class="secondDanxiang">
                          <div>
                            <el-tag type="danger">
                              {{ xm9_4Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_4Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_4Count - xm9_4Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm9_4hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm9_4jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_4buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm9_4bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_4weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm80" class="xiangmu">
                        <div v-if="id81" ref="id81" class="id81">
                          <el-tag
                            v-if="id81"
                            type="danger"
                            @click="changeShow('xm81')"
                          >
                            <div class="leftSum id81">
                              9.4.1原材料及外购件检验规程
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_4_1Panding"
                                @change="
                                  setMealSelect($event, 'xm9_4_1P', 'id81')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm81" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否有重要原材料及外购零部件检验规程
                                <span class="xm9_4_1Panding_1">
                                  <el-radio-group v-model="xm9_4_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                检验规程是否明确了以下内容
                                <span class="xm9_4_1Panding_2">
                                  <el-checkbox-group v-model="xm9_4_1Panding_2">
                                    <el-checkbox label="01">
                                      抽样基数和数量
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      检验项目
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      检验方法
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      检测检验设备
                                    </el-checkbox>
                                    <el-checkbox label="05">
                                      判定规则等,且不低于产品安标备案技术文件的要求。
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>

                              <p>
                                抽查了
                                <el-input
                                  v-model="xm9_4_1Panding_3"
                                  class="xm9_4_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                重要原材料及外购零部件检验规程。
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_4_1Panding_4"
                                  class="xm9_4_1Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id82" ref="id82" class="id82">
                          <el-tag
                            v-if="id82"
                            type="danger"
                            @click="changeShow('xm82')"
                          >
                            <div class="leftSum id82">9.4.2外协件检验规程</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_4_2Panding"
                                @change="
                                  setMealSelect($event, 'xm9_4_2P', 'id82')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm82" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否有外协件检验规程
                                <span class="xm9_4_2Panding_1">
                                  <el-radio-group v-model="xm9_4_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                检验规程是否明确了以下内容
                                <span class="xm9_4_2Panding_2">
                                  <el-checkbox-group v-model="xm9_4_2Panding_2">
                                    <el-checkbox label="01">
                                      抽样基数和数量
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      检验项目
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      检验方法
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      检测检验设备
                                    </el-checkbox>
                                    <el-checkbox label="05">
                                      判定规则等,且不低于产品安标备案技术文件的要求。
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>

                              <p>
                                抽查了
                                <el-input
                                  v-model="xm9_4_2Panding_3"
                                  class="xm9_4_2Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                外协件检验规程。
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_4_2Panding_4"
                                  class="xm9_4_2Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id83" ref="id83" class="id83">
                          <el-tag
                            v-if="id83"
                            type="danger"
                            @click="changeShow('xm83')"
                          >
                            <div class="leftSum id83">
                              9.4.3关键工序检验规程
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_4_3Panding"
                                @change="
                                  setMealSelect($event, 'xm9_4_3P', 'id83')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm83" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否有关键工序检验规程
                                <span class="xm9_4_3Panding_1">
                                  <el-radio-group v-model="xm9_4_3Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                检验规程是否明确了以下内容
                                <span class="xm9_4_3Panding_2">
                                  <el-checkbox-group v-model="xm9_4_3Panding_2">
                                    <el-checkbox label="01">
                                      抽样基数和数量
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      检验项目
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      检验方法
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      检测检验设备
                                    </el-checkbox>
                                    <el-checkbox label="05">
                                      判定规则等,且不低于产品安标备案技术文件的要求。
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>

                              <p>
                                抽查了
                                <el-input
                                  v-model="xm9_4_3Panding_3"
                                  class="xm9_4_3Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                关键工序操作规程。
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_4_3Panding_4"
                                  class="xm9_4_3Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id84" ref="id84" class="id84">
                          <el-tag
                            v-if="id84"
                            type="danger"
                            @click="changeShow('xm84')"
                          >
                            <div class="leftSum id84">9.4.4出厂检验规程</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_4_4Panding"
                                @change="
                                  setMealSelect($event, 'xm9_4_4P', 'id84')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm84" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否有出厂检验规程
                                <span class="xm9_4_4Panding_1">
                                  <el-radio-group v-model="xm9_4_4Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                检验规程是否明确了以下内容
                                <span class="xm9_4_4Panding_2">
                                  <el-checkbox-group v-model="xm9_4_4Panding_2">
                                    <el-checkbox label="01">
                                      抽样基数和数量
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      检验项目
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      检验方法
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      检测检验设备
                                    </el-checkbox>
                                    <el-checkbox label="05">
                                      判定规则等,且不低于产品安标备案技术文件的要求。
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>

                              <p>
                                抽查了
                                <el-input
                                  v-model="xm9_4_4Panding_3"
                                  class="xm9_4_4Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                产品出厂检验规程。
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_4_4Panding_4"
                                  class="xm9_4_4Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id85" ref="id85" class="id85">
                      <el-tag type="success" @click="changeShow('xm85')">
                        <div class="leftSum id85">9.5检验记录</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm9_5Panding"
                            @change="setMealSelect($event, 'xm9_5P', 'id85')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm85" class="xiangmu">
                        <div class="neirong">
                          <p>
                            外购（协）件进厂、加工过程是否按规定（检验规程中抽样比例、检验项目、技术要求等）进行检验或验证？
                            <span class="xm9_5Panding_1">
                              <el-radio-group v-model="xm9_5Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            是否保存相关检验记录/报告,记录/报告信息是否真实、规范？
                            <span class="xm9_5Panding_2">
                              <el-radio-group v-model="xm9_5Panding_2">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <el-card>
                            <p>
                              进厂检验记录1名称
                              <el-input
                                v-model="xm9_5Panding_3"
                                class="xm9_5Panding_3"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>

                              检验日期
                              <el-date-picker
                                v-model="xm9_5Panding_4"
                                type="date"
                                class="xm9_5Panding_4"
                                clearable
                                placeholder="请输入内容"
                                style="width: 20%"
                              ></el-date-picker>
                            </p>

                            <p>
                              进厂检验记录2名称
                              <el-input
                                v-model="xm9_5Panding_5"
                                class="xm9_5Panding_5"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>

                              检验日期
                              <el-date-picker
                                v-model="xm9_5Panding_6"
                                type="date"
                                class="xm9_5Panding_6"
                                clearable
                                placeholder="请输入内容"
                                style="width: 20%"
                              ></el-date-picker>
                            </p>
                            <p>
                              过程检验记录1名称
                              <el-input
                                v-model="xm9_5Panding_7"
                                class="xm9_5Panding_7"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>

                              检验日期
                              <el-date-picker
                                v-model="xm9_5Panding_8"
                                type="date"
                                class="xm9_5Panding_8"
                                clearable
                                placeholder="请输入内容"
                                style="width: 20%"
                              ></el-date-picker>
                            </p>
                            <p>
                              过程检验记录2名称
                              <el-input
                                v-model="xm9_5Panding_9"
                                class="xm9_5Panding_9"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>

                              检验日期
                              <el-date-picker
                                v-model="xm9_5Panding_10"
                                type="date"
                                class="xm9_5Panding_10"
                                clearable
                                placeholder="请输入内容"
                                style="width: 20%"
                              ></el-date-picker>
                            </p>
                          </el-card>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm9_5Panding_11"
                              class="xm9_5Panding_11"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id86" ref="id86" class="id86">
                      <el-tag type="success" @click="changeShow('xm86')">
                        <div class="leftSum id86">9.6计量检定与校准</div>
                        <div class="secondDanxiang">
                          <div>
                            <el-tag type="danger">
                              {{ xm9_6Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_6Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_6Count - xm9_6Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm9_6hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm9_6jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_6buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm9_6bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_6weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm86" class="xiangmu">
                        <div v-if="id87" ref="id87" class="id87">
                          <el-tag
                            v-if="id87"
                            type="danger"
                            @click="changeShow('xm87')"
                          >
                            <div class="leftSum id87">9.6.1周期检定或校准</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_6_1Panding"
                                @change="
                                  setMealSelect($event, 'xm9_6_1P', 'id87')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm87" class="xiangmu">
                            <div class="neirong">
                              <p>
                                检测检验设备是否按国家计量法规和有关计量检定规程/校准规范进行周期检定或校准？
                                <span class="xm9_6_1Panding_1">
                                  <el-radio-group v-model="xm9_6_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_6_1Panding_2"
                                  class="xm9_6_1Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id88" ref="id88" class="id88">
                          <el-tag
                            v-if="id88"
                            type="danger"
                            @click="changeShow('xm88')"
                          >
                            <div class="leftSum id88">9.6.2内部校准规范</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_6_2Panding"
                                @change="
                                  setMealSelect($event, 'xm9_6_2P', 'id88')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm88" class="xiangmu">
                            <div class="neirong">
                              <p>
                                没有检定规程、校准规范的检测检验设备是否制定内部校准规范,并按其进行内部校准？
                                <span class="xm9_6_2Panding_1">
                                  <el-radio-group v-model="xm9_6_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                自校仪表/设备名称
                                <el-input
                                  v-model="xm9_6_2Panding_2"
                                  class="xm9_6_2Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_6_2Panding_3"
                                  class="xm9_6_2Panding_3"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id89" ref="id89" class="id89">
                          <el-tag
                            v-if="id89"
                            type="danger"
                            @click="changeShow('xm89')"
                          >
                            <div class="leftSum id89">9.6.3内部检定文件</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_6_3Panding"
                                @change="
                                  setMealSelect($event, 'xm9_6_3P', 'id89')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm89" class="xiangmu">
                            <div class="neirong">
                              <p>
                                具备内部检定/校准资格的工厂,是否有文件规定检定/校准方法、验收准则和检定/校准周期等？
                                <span class="xm9_6_3Panding_1">
                                  <el-radio-group v-model="xm9_6_3Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                内部检定/校准资质
                                <el-input
                                  v-model="xm9_6_3Panding_2"
                                  class="xm9_6_3Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_6_3Panding_3"
                                  class="xm9_6_3Panding_3"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                检定/校准资质应拍照,保存在文件夹“检验设备及过程”。
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id90" ref="id90" class="id90">
                          <el-tag
                            v-if="id90"
                            type="danger"
                            @click="changeShow('xm90')"
                          >
                            <div class="leftSum id90">
                              9.6.4检测结果追溯评定
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_6_4Panding"
                                @change="
                                  setMealSelect($event, 'xm9_6_4P', 'id90')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in fourOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm90" class="xiangmu">
                            <div class="neirong">
                              <p>
                                当发现检测检验设备不符合要求时,是否对其以往检测结果的有效性进行追溯评定,并对该检测检验设备及受影响的产品采取适当的措施？
                                <span class="xm9_6_4Panding_1">
                                  <el-radio-group v-model="xm9_6_4Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                追溯评定记录
                                <el-input
                                  v-model="xm9_6_4Panding_2"
                                  class="xm9_6_4Panding_2"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                                编号
                                <el-input
                                  v-model="xm9_6_4Panding_3"
                                  class="xm9_6_4Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 40%"
                                ></el-input>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_6_4Panding_4"
                                  class="xm9_6_4Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id91" ref="id91" class="id91">
                          <el-tag
                            v-if="id91"
                            type="danger"
                            @click="changeShow('xm91')"
                          >
                            <div class="leftSum id91">9.6.5有效性标识</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_6_5Panding"
                                @change="
                                  setMealSelect($event, 'xm9_6_5P', 'id91')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm91" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否对检定或校准合格的检测检验设备进行有效性标识？
                                <span class="xm9_6_5Panding_1">
                                  <el-radio-group v-model="xm9_6_5Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_6_5Panding_2"
                                  class="xm9_6_5Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id92" ref="id92" class="id92">
                      <el-tag type="success" @click="changeShow('xm92')">
                        <div class="leftSum id92">9.7出厂检验</div>

                        <div class="secondDanxiang">
                          <div>
                            <el-tag type="danger">
                              {{ xm9_7Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_7Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_7Count - xm9_7Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm9_7hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm9_7jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_7buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm9_7bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm9_7weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>

                      <div ref="xm92" class="xiangmu">
                        <div v-if="id93" ref="id93" class="id93">
                          <el-tag
                            v-if="id93"
                            type="danger"
                            @click="changeShow('xm93')"
                          >
                            <div class="leftSum id93">
                              <i class="el-icon-warning"></i>

                              9.7.1出厂检验检测检验设备
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_7_1Panding"
                                @change="
                                  setMealSelect($event, 'xm9_7_1P', 'id93')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in twoOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm93" class="xiangmu">
                            <div class="neirong">
                              <p>
                                <span class="fouju">
                                  ★
                                  是否具备按标准要求进行出厂检验的检测检验设备？
                                </span>
                                <span class="xm9_7_1Panding_1">
                                  <el-radio-group v-model="xm9_7_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                是否严格按产品标准和安标审查备案技术文件要求（检验规程中抽样比例、检验项目、技术要求等）开展出厂检验工作,保存检验记录？
                                <span class="xm9_7_1Panding_2">
                                  <el-radio-group v-model="xm9_7_1Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                抽查了检验日期
                                <el-input
                                  v-model="xm9_7_1Panding_3"
                                  type="date"
                                  class="xm9_7_1Panding_3"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                <el-input
                                  v-model="xm9_7_1Panding_4"
                                  class="xm9_7_1Panding_4"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                <el-input
                                  v-model="xm9_7_1Panding_5"
                                  class="xm9_7_1Panding_5"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                ,出厂编号（批次）：
                                <el-input
                                  v-model="xm9_7_1Panding_6"
                                  class="xm9_7_1Panding_6"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                <el-input
                                  v-model="xm9_7_1Panding_7"
                                  class="xm9_7_1Panding_7"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                <el-input
                                  v-model="xm9_7_1Panding_8"
                                  class="xm9_7_1Panding_8"
                                  clearable
                                  placeholder="请输入内容"
                                  style="width: 150px"
                                ></el-input>
                                的产品出厂检验报告。
                              </p>
                              <p>
                                报告数量与8.1①条款中抽查的成品台账是否相符。
                                <span class="xm9_7_1Panding_9">
                                  <el-radio-group v-model="xm9_7_1Panding_9">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_7_1Panding_10"
                                  class="xm9_7_1Panding_10"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                出厂检验现场考评记录表见附表4。出厂检验报告及过程应拍照,保存在文件夹“检验设备及过程”。
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id94" ref="id94" class="id94">
                          <el-tag
                            v-if="id94"
                            type="danger"
                            @click="changeShow('xm94')"
                          >
                            <div class="leftSum id94">9.7.2检验报告内容</div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm9_7_2Panding"
                                @change="
                                  setMealSelect($event, 'xm9_7_2P', 'id94')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm94" class="xiangmu">
                            <div class="neirong">
                              <p>
                                检验报告中是否明确以下内容
                                <span class="xm9_7_2Panding_1">
                                  <el-checkbox-group v-model="xm9_7_2Panding_1">
                                    <el-checkbox label="01">
                                      产品名称
                                    </el-checkbox>
                                    <el-checkbox label="02">
                                      型号规格
                                    </el-checkbox>
                                    <el-checkbox label="03">
                                      产品编号
                                    </el-checkbox>
                                    <el-checkbox label="04">
                                      检验依据
                                    </el-checkbox>
                                    <el-checkbox label="05">项目</el-checkbox>
                                    <el-checkbox label="06">
                                      技术要求
                                    </el-checkbox>
                                    <el-checkbox label="07">
                                      实测结果
                                    </el-checkbox>
                                    <el-checkbox label="08">
                                      检验结论
                                    </el-checkbox>
                                    <el-checkbox label="09">日期</el-checkbox>
                                    <el-checkbox label="10">
                                      编制、审核人员等内容。
                                    </el-checkbox>
                                  </el-checkbox-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm9_7_2Panding_2"
                                  class="xm9_7_2Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div v-if="id95" ref="id95" class="id95">
                      <el-tag type="success" @click="changeShow('xm95')">
                        <div class="leftSum id95">9.8检验外包</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm9_8Panding"
                            @change="setMealSelect($event, 'xm9_8P', 'id95')"
                          >
                            <el-checkbox-button
                              v-for="option in fourOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm95" class="xiangmu">
                        <div class="neirong">
                          <p>
                            对于允许委托外部机构进行的检验（具体项目见产品审核发放实施规则）,是否能确保外部机构的能力满足检验要求,并保存对其能力的评价结果？
                            <span class="xm9_8Panding_1">
                              <el-radio-group v-model="xm9_8Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            委外检验项目
                            <el-input
                              v-model="xm9_8Panding_2"
                              class="xm9_8Panding_2"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p>
                            检验机构名称
                            <el-input
                              v-model="xm9_8Panding_3"
                              class="xm9_8Panding_3"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p>
                            检验机构资质、编号
                            <el-input
                              v-model="xm9_8Panding_4"
                              class="xm9_8Panding_4"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p>
                            评价结果
                            <el-input
                              v-model="xm9_8Panding_5"
                              class="xm9_8Panding_5"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm9_8Panding_6"
                              class="xm9_8Panding_6"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                          <p style="color: gray">
                            资质证明需拍照,保存在文件夹 “检验设备及过程”。
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id96" name="tab10" label="10不合格品控制">
            <!-- 10不合格品控制-->

            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id96" class="icon-panel">
                  <div slot="header" class="Sumary" @click="changeShow('xm96')">
                    <div class="leftSum">
                      <vab-icon
                        :icon="['fas', 'bullhorn']"
                        style="color: #ff85c0"
                      ></vab-icon>
                      10不合格品控制
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_10JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm10Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm10Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm10Count - xm10Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm10hege == '0' ? 'info' : 'success'">
                          {{ xm10hege }}合格
                        </el-tag>

                        <el-tag
                          :type="xm10jibenhege == '0' ? 'info' : 'danger'"
                        >
                          {{ xm10jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm10buhege == '0' ? 'info' : 'danger'">
                          {{ xm10buhege }}不合格
                        </el-tag>

                        <el-tag type="info">{{ xm10bushiyong }}不适用</el-tag>

                        <el-tag :type="xm10weipan == '0' ? 'info' : 'danger'">
                          {{ xm10weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm96" class="xiangmu">
                    <div v-if="id97" ref="id97" class="id97">
                      <el-tag type="success" @click="changeShow('xm97')">
                        <div class="leftSum id97">10.1管理制度</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm10_1Panding"
                            @change="setMealSelect($event, 'xm10_1P', 'id97')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm97" class="xiangmu">
                        <div class="neirong">
                          <p>
                            是否制定并实施不合格品控制管理制度？
                            <span class="xm10_1Panding_1">
                              <el-radio-group v-model="xm10_1Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            文件中是否明确以下内容
                            <span class="xm10_1Panding_2">
                              <el-checkbox-group v-model="xm10_1Panding_2">
                                <el-checkbox label="01">
                                  不合格品识别
                                </el-checkbox>
                                <el-checkbox label="02">
                                  不合格品评定
                                </el-checkbox>
                                <el-checkbox label="03">
                                  不合格品记录
                                </el-checkbox>
                                <el-checkbox label="04">
                                  不合格品处置的职责权限
                                </el-checkbox>
                              </el-checkbox-group>
                            </span>
                          </p>
                          <p>
                            文件名称
                            <el-input
                              v-model="xm10_1Panding_3"
                              class="xm10_1Panding_3"
                              clearable
                              placeholder="请输入内容"
                              style="width: 60%"
                            ></el-input>
                          </p>
                          <p>
                            编号
                            <el-input
                              v-model="xm10_1Panding_4"
                              class="xm10_1Panding_4"
                              clearable
                              placeholder="请输入内容"
                              style="width: 30%"
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm10_1Panding_5"
                              class="xm10_1Panding_5"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id98" ref="id98" class="id98">
                      <el-tag type="success" @click="changeShow('xm98')">
                        <div class="leftSum id98">10.2不合格品处理</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm10_2Panding"
                            @change="setMealSelect($event, 'xm10_2P', 'id98')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm98" class="xiangmu">
                        <div class="neirong">
                          <p>
                            对采购（外协）、生产、检验等环节中发现的不合格品,是否采取标识、隔离、处置等措施,返工或返修后的产品是否重新检验？
                            <span class="xm10_2Panding_1">
                              <el-radio-group v-model="xm10_2Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <el-card>
                            <p>
                              不合格品名称
                              <el-input
                                v-model="xm10_2Panding_2"
                                class="xm10_2Panding_2"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              编号或日期
                              <el-input
                                v-model="xm10_2Panding_3"
                                class="xm10_2Panding_3"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              处置措施
                              <el-input
                                v-model="xm10_2Panding_4"
                                class="xm10_2Panding_4"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              重新检验日期
                              <el-date-picker
                                v-model="xm10_2Panding_5"
                                class="xm10_2Panding_5"
                                type="date"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-date-picker>
                              结论
                              <el-input
                                v-model="xm10_2Panding_6"
                                class="xm10_2Panding_6"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                          </el-card>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm10_2Panding_7"
                              class="xm10_2Panding_7"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id99" ref="id99" class="id99">
                      <el-tag type="success" @click="changeShow('xm99')">
                        <div class="leftSum id99">10.3纠正及验证</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm10_3Panding"
                            @change="setMealSelect($event, 'xm10_3P', 'id99')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm99" class="xiangmu">
                        <div class="neirong">
                          <p>
                            是否收集、整理不合格品信息,尤其是用户反馈的质量信息,查明产生不合格或潜在不合格的原因并记录,制定相应的纠正措施或预防措施并对其实施跟踪验证？
                            <span class="xm10_3Panding_1">
                              <el-radio-group v-model="xm10_3Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm10_3Panding_2"
                              class="xm10_3Panding_2"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id100" ref="id100" class="id100">
                      <el-tag type="success" @click="changeShow('xm100')">
                        <div class="leftSum id100">10.4销售约束</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm10_4Panding"
                            @change="setMealSelect($event, 'xm10_4P', 'id100')"
                          >
                            <el-checkbox-button
                              v-for="option in fourOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm100" class="xiangmu">
                        <div class="neirong">
                          <p>
                            不满足安全性能要求的产品,是否销往矿山？
                            <span class="xm10_4Panding_1">
                              <el-radio-group v-model="xm10_4Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm10_4Panding_2"
                              class="xm10_4Panding_2"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id101" ref="id101" class="id101">
                      <el-tag type="success" @click="changeShow('xm101')">
                        <div class="leftSum id101">10.5相关处理及信息留存</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm10_5Panding"
                            @change="setMealSelect($event, 'xm10_5P', 'id101')"
                          >
                            <el-checkbox-button
                              v-for="option in fourOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm101" class="xiangmu">
                        <div class="neirong">
                          <p>
                            对于已出厂产品,获知存在重大质量或安全问题时,是否及时通知安标国家中心和用户,并采取相应措施,消除安全隐患？
                            <span class="xm10_5Panding_1">
                              <el-radio-group v-model="xm10_5Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            对无法跟踪的不合格产品是否通过公开出版物、网站向社会公告？
                            <span class="xm10_5Panding_2">
                              <el-radio-group v-model="xm10_5Panding_2">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            对于上述不合格产品,应对以下记录保存至少10年：
                            <span class="xm10_5Panding_3">
                              <el-checkbox-group v-model="xm10_5Panding_3">
                                <el-checkbox label="01">
                                  产品的出厂编号和标识
                                </el-checkbox>
                                <el-checkbox label="02">
                                  产品客户信息
                                </el-checkbox>
                                <el-checkbox label="03">
                                  通知客户采取的措施
                                </el-checkbox>
                                <el-checkbox label="04">
                                  工厂的纠正和预防措施
                                </el-checkbox>
                              </el-checkbox-group>
                            </span>
                          </p>
                          <el-card>
                            <p>
                              不合格产品名称
                              <el-input
                                v-model="xm10_5Panding_4"
                                class="xm10_5Panding_4"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              型号
                              <el-input
                                v-model="xm10_5Panding_5"
                                class="xm10_5Panding_5"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              出厂编号
                              <el-input
                                v-model="xm10_5Panding_6"
                                class="xm10_5Panding_6"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              用户名称
                              <el-input
                                v-model="xm10_5Panding_7"
                                class="xm10_5Panding_7"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              通知客户采取措施
                              <el-input
                                v-model="xm10_5Panding_8"
                                class="xm10_5Panding_8"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                            <p>
                              纠正措施
                              <el-input
                                v-model="xm10_5Panding_9"
                                class="xm10_5Panding_9"
                                clearable
                                placeholder="请输入内容"
                                style="width: 40%"
                              ></el-input>
                            </p>
                          </el-card>

                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm10_5Panding_10"
                              class="xm10_5Panding_10"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id102" name="tab11" label="11变更及一致性控制">
            <!-- 11变更及一致性控制-->

            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id102" class="icon-panel">
                  <div
                    slot="header"
                    class="Sumary"
                    @click="changeShow('xm102')"
                  >
                    <div class="leftSum id102">
                      <vab-icon
                        :icon="['fas', 'book']"
                        style="color: #69c0ff"
                      ></vab-icon>
                      11变更及一致性控制
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_11JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm11Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm11Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm11Count - xm11Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm11hege == '0' ? 'info' : 'success'">
                          {{ xm11hege }}合格
                        </el-tag>

                        <el-tag
                          :type="xm11jibenhege == '0' ? 'info' : 'danger'"
                        >
                          {{ xm11jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm11buhege == '0' ? 'info' : 'danger'">
                          {{ xm11buhege }}不合格
                        </el-tag>

                        <el-tag type="info">{{ xm11bushiyong }}不适用</el-tag>

                        <el-tag :type="xm11weipan == '0' ? 'info' : 'danger'">
                          {{ xm11weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm102" class="xiangmu">
                    <div v-if="id103" ref="id103" class="id103">
                      <el-tag type="success" @click="changeShow('xm103')">
                        <div class="leftSum id103">11.1 变更控制</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm11_1Panding"
                            @change="setMealSelect($event, 'xm11_1P', 'id103')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm103" class="xiangmu">
                        <div class="neirong">
                          <p>
                            是否制定变更控制管理制度
                            <span class="xm11_1Panding_1">
                              <el-radio-group v-model="xm11_1Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            应对工商注册信息、生产地址以及其他可能影响产品一致性及产品与标准符合性（如工艺、生产条件、主要零部件和产品结构等）的变更进行控制,根据安标管理要求,需向安标国家中心提交变更申请的,应履行变更程序。
                          </p>
                          <p>
                            文件名称
                            <el-input
                              v-model="xm11_1Panding_2"
                              class="xm11_1Panding_2"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                            编号
                            <el-input
                              v-model="xm11_1Panding_3"
                              class="xm11_1Panding_3"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm11_1Panding_4"
                              class="xm11_1Panding_4"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id104" ref="id104" class="id104">
                      <el-tag type="success" @click="changeShow('xm104')">
                        <div class="leftSum id104">
                          <i class="el-icon-warning"></i>

                          11.2产品一致性控制
                        </div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm11_2Panding"
                            @change="setMealSelect($event, 'xm11_2P', 'id104')"
                          >
                            <el-checkbox-button
                              v-for="option in twoOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm104" class="xiangmu">
                        <div class="neirong">
                          <p>
                            <span class="fouju" style="width: 80%">
                              ★是否从产品采购、外协、生产、工艺、检验、交付等环节对产品一致性进行控制,按照安标备案的技术文件组织生产,确保产品持续符合安全标志审核发放要求？
                            </span>
                            <span class="xm11_2Panding_1">
                              <el-radio-group v-model="xm11_2Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p style="height: 75px">
                            控制措施
                            <el-input
                              v-model="xm11_2Panding_2"
                              class="xm11_2Panding_2"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入控制措施"
                              clearable
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm11_2Panding_3"
                              class="xm11_2Panding_3"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                          <p style="color: gray">
                            产品一致性核查记录表见附表5。主要零元部件和重要原材料复印表核实记录及照片见文件夹“一致性核实”。
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id105" ref="id105" class="id105">
                      <el-tag type="success" @click="changeShow('xm105')">
                        <div class="leftSum id105">11.3产品可追溯性</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm11_3Panding"
                            @change="setMealSelect($event, 'xm11_3P', 'id105')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm105" class="xiangmu">
                        <div class="neirong">
                          <p>
                            是否在产品生产、检验和交付的全过程能进行有效识别,保证产品重要组成部分的可追溯性？
                            <span class="xm11_3Panding_1">
                              <el-radio-group v-model="xm11_3Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            识别措施
                            <el-input
                              v-model="xm11_3Panding_2"
                              class="xm11_3Panding_2"
                              clearable
                              type="textarea"
                              :rows="2"
                              placeholder="请输入内容"
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm11_3Panding_3"
                              class="xm11_3Panding_3"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id106" name="tab12" label="12库房管理">
            <!-- 12库房管理-->

            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id106" class="icon-panel">
                  <div
                    slot="header"
                    class="Sumary"
                    @click="changeShow('xm106')"
                  >
                    <div class="leftSum id106">
                      <vab-icon
                        :icon="['fas', 'laptop-code']"
                        style="color: #5cdbd3"
                      ></vab-icon>
                      12库房管理
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_12JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm12Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm12Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm12Count - xm12Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm12hege == '0' ? 'info' : 'success'">
                          {{ xm12hege }}合格
                        </el-tag>

                        <el-tag
                          :type="xm12jibenhege == '0' ? 'info' : 'danger'"
                        >
                          {{ xm12jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm12buhege == '0' ? 'info' : 'danger'">
                          {{ xm12buhege }}不合格
                        </el-tag>

                        <el-tag type="info">{{ xm12bushiyong }}不适用</el-tag>

                        <el-tag :type="xm12weipan == '0' ? 'info' : 'danger'">
                          {{ xm12weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm106" class="xiangmu">
                    <div v-if="id107" ref="id107" class="id107">
                      <el-tag type="success" @click="changeShow('xm107')">
                        <div class="leftSum id107">12.1管理制度</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm12_1Panding"
                            @change="setMealSelect($event, 'xm12_1P', 'id107')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm107" class="xiangmu">
                        <div class="neirong">
                          <p>
                            是否制定并实施出入库、贮存管理制度,并明确出入库要求？
                            <span class="xm12_1Panding_1">
                              <el-radio-group v-model="xm12_1Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            文件名称
                            <el-input
                              v-model="xm12_1Panding_2"
                              class="xm12_1Panding_2"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                            编号
                            <el-input
                              v-model="xm12_1Panding_3"
                              class="xm12_1Panding_3"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm12_1Panding_4"
                              class="xm12_1Panding_4"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id108" ref="id108" class="id108">
                      <el-tag type="success" @click="changeShow('xm108')">
                        <div class="leftSum id108">12.2库房管理</div>
                        <div class="secondDanxiang">
                          <div class="tipCount">
                            <el-tag type="danger">
                              {{ xm12_2Count }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm12_2Foujue }}
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm12_2Count - xm12_2Foujue }}
                            </el-tag>
                          </div>
                          <div class="tipPanding">
                            <el-tag type="success">{{ xm12_2hege }}合格</el-tag>

                            <el-tag type="danger">
                              {{ xm12_2jibenhege }}基本
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm12_2buhege }}不合格
                            </el-tag>

                            <el-tag type="info">
                              {{ xm12_2bushiyong }}不适用
                            </el-tag>

                            <el-tag type="danger">
                              {{ xm12_2weipan }}未判定
                            </el-tag>
                          </div>
                        </div>
                      </el-tag>
                      <div ref="xm108" class="xiangmu">
                        <div v-if="id109" ref="id109" class="id109">
                          <el-tag
                            v-if="id109"
                            type="danger"
                            @click="changeShow('xm109')"
                          >
                            <div class="leftSum id109">
                              12.2.1分类存放并标识
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm12_2_1Panding"
                                @change="
                                  setMealSelect($event, 'xm12_2_1P', 'id109')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm109" class="xiangmu">
                            <div class="neirong">
                              <p>
                                贮存物品是否分类存放并标识,标识是否清晰、明确？
                                <span class="xm12_2_1Panding_1">
                                  <el-radio-group v-model="xm12_2_1Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm12_2_1Panding_2"
                                  class="xm12_2_1Panding_2"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                              <p style="color: gray">
                                对库房应进行拍照,保存在文件夹“生产现场及设备”。
                              </p>
                            </div>
                          </div>
                        </div>
                        <div v-if="id110" ref="id110" class="id110">
                          <el-tag
                            v-if="id110"
                            type="danger"
                            @click="changeShow('xm110')"
                          >
                            <div class="leftSum id110">
                              12.2.2原材料半成品成品台账
                            </div>
                            <div class="danxiang">
                              <el-checkbox-group
                                v-model="xm12_2_2Panding"
                                @change="
                                  setMealSelect($event, 'xm12_2_2P', 'id110')
                                "
                              >
                                <el-checkbox-button
                                  v-for="option in threeOptions"
                                  :key="option"
                                  :label="option"
                                >
                                  {{ option }}
                                </el-checkbox-button>
                              </el-checkbox-group>
                            </div>
                          </el-tag>
                          <div ref="xm110" class="xiangmu">
                            <div class="neirong">
                              <p>
                                是否建立了零（元）部件、原材料台账、半成品台账、成品台账？
                                <span class="xm12_2_2Panding_1">
                                  <el-radio-group v-model="xm12_2_2Panding_1">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                是否实施入库、领料手续？
                                <span class="xm12_2_2Panding_2">
                                  <el-radio-group v-model="xm12_2_2Panding_2">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p>
                                出入库记录是否齐全、账物相符？
                                <span class="xm12_2_2Panding_3">
                                  <el-radio-group v-model="xm12_2_2Panding_3">
                                    <el-radio label="是">是</el-radio>
                                    <el-radio label="否">否</el-radio>
                                    <el-radio label="欠">有欠缺</el-radio>
                                  </el-radio-group>
                                </span>
                              </p>
                              <p style="height: 75px">
                                不符合事实：
                                <el-input
                                  v-model="xm12_2_2Panding_4"
                                  class="xm12_2_2Panding_4"
                                  type="textarea"
                                  :rows="2"
                                  placeholder="请输入不合格事实"
                                  clearable
                                ></el-input>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div v-if="id111" ref="id111" class="id111">
                      <el-tag type="success" @click="changeShow('xm111')">
                        <div class="leftSum id111">12.3贮存条件</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm12_3Panding"
                            @change="setMealSelect($event, 'xm12_3P', 'id111')"
                          >
                            <el-checkbox-button
                              v-for="option in fourOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm111" class="xiangmu">
                        <div class="neirong">
                          <p>
                            库房贮存条件、环境是否符合产品贮存要求（如化学品存放的温、湿度要求，电子元件的防尘、隔离保护等）？
                            <span class="xm12_3Panding_1">
                              <el-radio-group v-model="xm12_3Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p style="height: 75px">
                            环境条件
                            <el-input
                              v-model="xm12_3Panding_2"
                              class="xm12_3Panding_2"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入环境条件"
                              clearable
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm12_3Panding_3"
                              class="xm12_3Panding_3"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane v-if="id112" name="tab13" label="13安全标志标识">
            <!-- 13安全标志标识-->
            <el-row>
              <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
                <el-card v-show="id112" class="icon-panel">
                  <div
                    slot="header"
                    class="Sumary"
                    @click="changeShow('xm112')"
                  >
                    <div class="leftSum id112">
                      <vab-icon
                        :icon="['fas', 'table']"
                        style="color: #5cdbd3"
                      ></vab-icon>
                      13安全标志标识
                    </div>
                    <div class="rigthSum">
                      <div class="jiedai">
                        <el-input
                          v-model="xm_13JieDai"
                          placeholder="接待人"
                          size="mini"
                          clearable
                          @click.stop.native="stopstop"
                        ></el-input>
                      </div>
                      共
                      <el-tag
                        type="danger"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm13Count }}
                      </el-tag>
                      项,其中,否决项
                      <el-tag
                        type="success"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm13Foujue }}
                      </el-tag>
                      ,考核项
                      <el-tag
                        type="warning"
                        style="margin-left: 0px; margin-right: 0px"
                      >
                        {{ xm13Count - xm13Foujue }}
                      </el-tag>
                      项。
                      <div class="yiji_tipPanding">
                        <el-tag :type="xm13hege == '0' ? 'info' : 'success'">
                          {{ xm13hege }}合格
                        </el-tag>

                        <el-tag
                          :type="xm13jibenhege == '0' ? 'info' : 'danger'"
                        >
                          {{ xm13jibenhege }}基本
                        </el-tag>

                        <el-tag :type="xm13buhege == '0' ? 'info' : 'danger'">
                          {{ xm13buhege }}不合格
                        </el-tag>

                        <el-tag
                          v-if="hide_panding"
                          :type="xm13bushiyong == '0' ? 'info' : 'danger'"
                        >
                          {{ xm13bushiyong }}不适用
                        </el-tag>

                        <el-tag :type="xm13weipan == '0' ? 'info' : 'danger'">
                          {{ xm13weipan }}未判定
                        </el-tag>
                      </div>
                    </div>
                  </div>
                  <span></span>
                  <div ref="xm112" class="xiangmu">
                    <div v-if="id113" ref="id113" class="id113">
                      <el-tag type="success" @click="changeShow('xm113')">
                        <div class="leftSum id113">13.1标识许可</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm13_1Panding"
                            @change="setMealSelect($event, 'xm13_1P', 'id113')"
                          >
                            <el-checkbox-button
                              v-for="option in twoOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm113" class="xiangmu">
                        <div class="neirong">
                          <p>
                            取得安全标志的产品,加施的安全标志标识是否经安标国家中心许可？
                            <span class="xm13_1Panding_1">
                              <el-radio-group v-model="xm13_1Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                              </el-radio-group>
                            </span>
                          </p>

                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm13_1Panding_2"
                              class="xm13_1Panding_2"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id114" ref="id114" class="id114">
                      <el-tag type="success" @click="changeShow('xm114')">
                        <div class="leftSum id114">13.2标识要求</div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm13_2Panding"
                            @change="setMealSelect($event, 'xm13_2P', 'id114')"
                          >
                            <el-checkbox-button
                              v-for="option in threeOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm114" class="xiangmu">
                        <div class="neirong">
                          <p>
                            加施的标识是否符合AQ1043标准要求,MA标识不得采用铝质及轻合金材料？
                            <span class="xm13_2Panding_1">
                              <el-radio-group v-model="xm13_2Panding_1">
                                <el-radio label="是">是</el-radio>
                                <el-radio label="否">否</el-radio>
                                <el-radio label="欠">有欠缺</el-radio>
                              </el-radio-group>
                            </span>
                          </p>
                          <p>
                            标识材质
                            <el-input
                              v-model="xm13_2Panding_2"
                              class="xm13_2Panding_2"
                              clearable
                              placeholder="请输入内容"
                              style="width: 40%"
                            ></el-input>
                          </p>
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm13_2Panding_3"
                              class="xm13_2Panding_3"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-if="id115" ref="id115" class="id115">
                      <el-tag type="success" @click="changeShow('xm115')">
                        <div class="leftSum id115">
                          <i class="el-icon-warning"></i>

                          13.3禁止加施标识
                        </div>
                        <div class="danxiang">
                          <el-checkbox-group
                            v-model="xm13_3Panding"
                            @change="setMealSelect($event, 'xm13_3P', 'id115')"
                          >
                            <el-checkbox-button
                              v-for="option in twoOptions"
                              :key="option"
                              :label="option"
                            >
                              {{ option }}
                            </el-checkbox-button>
                          </el-checkbox-group>
                        </div>
                      </el-tag>
                      <div ref="xm115" class="xiangmu">
                        <p style="height: 75px">
                          <span class="fouju">
                            ★下列产品是否未加施安全标志标识？
                          </span>
                          <span class="xm13_3Panding_1">
                            <el-checkbox-group v-model="xm13_3Panding_1">
                              <el-checkbox label="01">
                                未取得安全标志的产品
                              </el-checkbox>
                              <el-checkbox label="02">
                                获证后发生变更,未履行完成变更程序的产品
                              </el-checkbox>
                              <el-checkbox label="03">
                                超过安全标志有效期后生产的产品
                              </el-checkbox>
                              <el-checkbox label="04">
                                被撤销、注销安全标志的产品
                              </el-checkbox>
                              <el-checkbox label="05">
                                安全标志处于暂停状态期间的产品
                              </el-checkbox>
                              <el-checkbox label="06">不合格产品</el-checkbox>
                            </el-checkbox-group>
                          </span>
                        </p>

                        <div class="neirong">
                          <p style="height: 75px">
                            不符合事实：
                            <el-input
                              v-model="xm13_3Panding_2"
                              class="xm13_3Panding_2"
                              type="textarea"
                              :rows="2"
                              placeholder="请输入不合格事实"
                              clearable
                            ></el-input>
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-tab-pane>
        </el-tabs>
      </el-col>
      <el-col
        id="searchBar"
        class="isFixed"
        :xs="24"
        :sm="24"
        :md="24"
        :lg="1"
        :xl="1"
      >
        <div>
          <el-card shadow="never">
            <div slot="header">
              <div class="use-flexbox">
                <el-dialog
                  title="提示"
                  :visible.sync="dialogVisible"
                  width="80%"
                  height="100%"
                  :before-close="handleClose"
                >
                  <iframe
                    src="http://117.160.199.82:7777"
                    frameborder="0"
                    width="100%"
                    height="600px"
                  ></iframe>
                  <span slot="footer" class="dialog-footer">
                    <el-button @click="dialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click="dialogVisible = false">
                      确 定
                    </el-button>
                  </span>
                </el-dialog>
                <el-button type="danger" @click="saveData">保存数据</el-button>
                <el-button type="primary" @click="jiaoyan">校验数据</el-button>
                <el-button type="primary" @click="qinchu">清除标记</el-button>
              </div>
              <el-divider content-position="left"></el-divider>
              <div class="use-flexbox">
                <el-input v-model="filterText" placeholder="输入关键字过滤" />
                <span>
                  <el-checkbox
                    v-model="checkAll"
                    :indeterminate="isIndeterminate"
                    @change="handleCheckAllChange"
                  >
                    全选
                  </el-checkbox>

                  <el-checkbox @change="inverse">反选</el-checkbox>
                </span>
                <span>
                  <el-checkbox
                    v-model="defaultExpendedAll"
                    :indeterminate="isIndeterminate"
                    @change="treestate"
                  >
                    展开
                  </el-checkbox>

                  <el-checkbox @change="changeShow('xm-0')">隐藏</el-checkbox>
                </span>
              </div>
            </div>
            <div ref="xm-0" class="xiangmu">
              <el-tree
                ref="demoTree"
                :data="data2"
                :default-checked-keys="defaultCheckedKeys"
                :default-expanded-keys="defaultExpendedKeys"
                :default-expanded-all="defaultExpendedAll"
                :expand-on-click-node="false"
                :filter-node-method="filterNode"
                :highlight-current="true"
                :props="defaultProps"
                class="vab-filter-tree"
                node-key="id"
                default-expand-all
                show-checkbox
                @check="checkNode"
                @check-change="checkChange"
                @node-click="nodeClick"
                @node-collapse="nodeCollapse"
                @node-expand="nodeExpand"
              ></el-tree>
            </div>
          </el-card>
        </div>
      </el-col>
    </el-row>
    <mypdfView ref="edit" :filePath="pdf_src"></mypdfView>
  </div>
</template>
<script>
  import { getTreeList } from '@/api/tree'

  import { mapActions, mapGetters } from 'vuex'
  import mypdfView from './components/mypdfView'

  import $ from 'jquery'
  //2、通过npm安装
  import messagebox from 'jj-messagebox'
  const axios = require('axios').default

  //注册全部插件（alert,dialog,popup,loading,toast）
  const TwoOptions = ['符合', '不符']
  const ThreeOptions = ['符合', '基本', '不符']
  const ThreeOptions0 = ['符合', '不符', '不适用']
  const FourOptions = ['符合', '基本', '不符', '不适用']
  const treeOptions = [
    '1',
    '4',
    '13',
    '21',
    '35',
    '44',
    '60',
    '72',
    '96',
    '102',
    '106',
    '112',
  ]
  const PANDINGLIST = [
    'xm2_1Panding_1',
    'xm2_1Panding_2',
    'xm2_1Panding_3',
    'xm2_1Panding_4',
    'xm2_2Panding_1',
    'xm2_2Panding_2',
    'xm2_2Panding_3',
    'xm2_2Panding_4',
    'xm2_2Panding_5',
    'xm2_2Panding_6',
    'xm3_1_1Panding_1',
    'xm3_1_1Panding_2',
    'xm3_1_1Panding_3',
    'xm3_1_2Panding_1',
    'xm3_1_2Panding_2',
    'xm3_1_2Panding_3',
    'xm3_1_2Panding_4',
    'xm3_2_1Panding_1',
    'xm3_2_1Panding_2',
    'xm3_2_1Panding_3',
    'xm3_2_1Panding_4',
    'xm3_2_1Panding_5',
    'xm3_2_1Panding_6',
    'xm3_2_1Panding_7',
    'xm3_2_1Panding_8',
    'xm3_2_1Panding_9',
    'xm3_2_2Panding_1',
    'xm3_2_2Panding_2',
    'xm3_2_2Panding_3',
    'xm3_2_2Panding_4',
    'xm3_2_2Panding_5',
    'xm3_2_2Panding_6',
    'xm3_2_3Panding_1',
    'xm3_2_3Panding_2',
    'xm3_2_3Panding_3',
    'xm3_2_4Panding_1',
    'xm3_2_4Panding_2',
    'xm4_1_1Panding_1',
    'xm4_1_1Panding_2',
    'xm4_1_1Panding_3',
    'xm4_1_1Panding_4',
    'xm4_1_1Panding_5',
    'xm4_1_1Panding_6',
    'xm4_1_1Panding_7',
    'xm4_1_1Panding_8',
    'xm4_1_2Panding_1',
    'xm4_1_2Panding_2',
    'xm4_2_1Panding_1',
    'xm4_2_1Panding_2',
    'xm4_2_1Panding_3',
    'xm4_2_1Panding_4',
    'xm4_2_1Panding_5',
    'xm4_2_1Panding_6',
    'xm4_2_1Panding_7',
    'xm4_2_1Panding_8',
    'xm4_2_2Panding_1',
    'xm4_2_2Panding_2',
    'xm4_3Panding_1',
    'xm4_3Panding_2',
    'xm4_3Panding_3',
    'xm4_3Panding_4',
    'xm4_3Panding_5',
    'xm4_3Panding_6',
    'xm4_3Panding_7',
    'xm4_3Panding_8',
    'xm4_3Panding_9',
    'xm4_3Panding_10',
    'xm4_3Panding_11',
    'xm4_3Panding_12',
    'xm5_1_1Panding_1',
    'xm5_1_1Panding_2',
    'xm5_1_1Panding_3',
    'xm5_1_1Panding_4',
    'xm5_1_2Panding_1',
    'xm5_1_2Panding_2',
    'xm5_1_2Panding_3',
    'xm5_1_2Panding_4',
    'xm5_1_2Panding_5',
    'xm5_1_2Panding_6',
    'xm5_1_2Panding_7',
    'xm5_1_2Panding_8',
    'xm5_2_1Panding_1',
    'xm5_2_1Panding_2',
    'xm5_2_1Panding_3',
    'xm5_2_1Panding_4',
    'xm5_2_1Panding_5',
    'xm5_2_1Panding_6',
    'xm5_2_1Panding_7',
    'xm5_2_1Panding_8',
    'xm5_2_1Panding_9',
    'xm5_2_1Panding_10',
    'xm5_2_1Panding_11',
    'xm5_2_1Panding_12',
    'xm5_2_1Panding_13',
    'xm5_2_1Panding_14',
    'xm5_2_1Panding_15',
    'xm5_2_1Panding_16',
    'xm5_2_1Panding_17',
    'xm5_2_1Panding_18',
    'xm5_2_1Panding_19',
    'xm5_2_1Panding_20',
    'xm5_2_2Panding_1',
    'xm5_2_2Panding_2',
    'xm5_2_2Panding_3',
    'xm5_3_1Panding_1',
    'xm5_3_1Panding_2',
    'xm5_3_1Panding_3',
    'xm5_3_1Panding_4',
    'xm5_3_1Panding_5',
    'xm5_3_1Panding_6',
    'xm5_3_1Panding_7',
    'xm5_3_2Panding_1',
    'xm5_3_2Panding_2',
    'xm5_3_2Panding_3',
    'xm5_3_2Panding_4',
    'xm5_3_2Panding_5',
    'xm5_3_2Panding_6',
    'xm5_3_2Panding_7',
    'xm5_4_1Panding_1',
    'xm5_4_1Panding_2',
    'xm5_4_1Panding_3',
    'xm5_4_1Panding_4',
    'xm5_4_1Panding_5',
    'xm5_4_1Panding_6',
    'xm5_4_1Panding_7',
    'xm5_4_1Panding_8',
    'xm5_4_1Panding_9',
    'xm5_4_1Panding_10',
    'xm5_4_1Panding_11',
    'xm5_4_1Panding_12',
    'xm5_4_1Panding_13',
    'xm5_4_1Panding_14',
    'xm5_4_2Panding_1',
    'xm5_4_2Panding_2',
    'xm5_4_2Panding_3',
    'xm5_4_2Panding_4',
    'xm5_4_2Panding_5',
    'xm5_4_2Panding_6',
    'xm5_4_2Panding_7',
    'xm5_4_2Panding_8',
    'xm5_4_2Panding_9',
    'xm5_4_2Panding_10',
    'xm5_4_2Panding_11',
    'xm5_5Panding_1',
    'xm5_5Panding_2',
    'xm5_5Panding_3',
    'xm6_1_1Panding_1',
    'xm6_1_1Panding_2',
    'xm6_1_1Panding_3',
    'xm6_1_1Panding_4',
    'xm6_1_1Panding_5',
    'xm6_1_2Panding_1',
    'xm6_1_2Panding_2',
    'xm6_1_2Panding_3',
    'xm6_1_2Panding_4',
    'xm6_1_2Panding_5',
    'xm6_1_2Panding_6',
    'xm6_1_2Panding_7',
    'xm6_1_2Panding_8',
    'xm6_1_2Panding_9',
    'xm6_1_2Panding_10',
    'xm6_1_3Panding_1',
    'xm6_1_3Panding_2',
    'xm6_1_3Panding_3',
    'xm6_1_3Panding_4',
    'xm6_1_3Panding_5',
    'xm6_1_3Panding_6',
    'xm6_1_4Panding_1',
    'xm6_1_4Panding_2',
    'xm6_2_1Panding_1',
    'xm6_2_1Panding_2',
    'xm6_2_1Panding_3',
    'xm6_2_1Panding_4',
    'xm6_2_1Panding_5',
    'xm6_2_1Panding_6',
    'xm6_2_1Panding_7',
    'xm6_2_1Panding_8',
    'xm6_2_2Panding_1',
    'xm6_2_2Panding_2',
    'xm6_2_2Panding_3',
    'xm6_2_2Panding_4',
    'xm6_2_2Panding_5',
    'xm7_1_1Panding_1',
    'xm7_1_1Panding_2',
    'xm7_1_1Panding_3',
    'xm7_1_1Panding_4',
    'xm7_1_1Panding_5',
    'xm7_1_2Panding_1',
    'xm7_1_2Panding_2',
    'xm7_1_2Panding_3',
    'xm7_1_2Panding_4',
    'xm7_1_2Panding_5',
    'xm7_1_2Panding_6',
    'xm7_1_2Panding_7',
    'xm7_1_2Panding_8',
    'xm7_1_2Panding_9',
    'xm7_1_2Panding_10',
    'xm7_1_2Panding_11',
    'xm7_1_2Panding_12',
    'xm7_1_2Panding_13',
    'xm7_1_2Panding_14',
    'xm7_1_3Panding_1',
    'xm7_1_3Panding_2',
    'xm7_1_4Panding_1',
    'xm7_1_4Panding_2',
    'xm7_1_4Panding_3',
    'xm7_1_4Panding_4',
    'xm7_1_4Panding_5',
    'xm7_1_4Panding_6',
    'xm7_1_4Panding_7',
    'xm7_1_4Panding_8',
    'xm7_1_4Panding_9',
    'xm7_1_4Panding_10',
    'xm7_1_4Panding_11',
    'xm7_1_5Panding_1',
    'xm7_1_5Panding_2',
    'xm7_1_5Panding_3',
    'xm7_1_5Panding_4',
    'xm7_1_5Panding_5',
    'xm7_1_5Panding_6',
    'xm7_1_5Panding_7',
    'xm7_1_5Panding_8',
    'xm7_1_5Panding_9',
    'xm7_1_6Panding_1',
    'xm7_1_6Panding_2',
    'xm7_1_6Panding_3',
    'xm7_1_6Panding_4',
    'xm7_1_6Panding_5',
    'xm7_1_6Panding_6',
    'xm7_2_1Panding_1',
    'xm7_2_1Panding_2',
    'xm7_2_1Panding_3',
    'xm7_2_1Panding_4',
    'xm7_2_1Panding_5',
    'xm7_2_2Panding_1',
    'xm7_2_2Panding_2',
    'xm7_2_2Panding_3',
    'xm7_2_2Panding_4',
    'xm7_2_2Panding_5',
    'xm7_2_2Panding_6',
    'xm7_2_2Panding_7',
    'xm7_2_2Panding_8',
    'xm7_2_2Panding_9',
    'xm7_2_2Panding_10',
    'xm7_2_2Panding_11',
    'xm7_2_2Panding_12',
    'xm7_2_3Panding_1',
    'xm7_2_3Panding_2',
    'xm7_2_4Panding_1',
    'xm7_2_4Panding_2',
    'xm7_2_4Panding_3',
    'xm7_2_4Panding_4',
    'xm7_2_4Panding_5',
    'xm7_2_4Panding_6',
    'xm7_2_4Panding_7',
    'xm7_2_4Panding_8',
    'xm7_2_4Panding_9',
    'xm7_2_4Panding_10',
    'xm7_2_4Panding_11',
    'xm7_2_5Panding_1',
    'xm7_2_5Panding_2',
    'xm7_2_5Panding_3',
    'xm7_2_6Panding_1',
    'xm7_2_6Panding_2',
    'xm7_2_6Panding_3',
    'xm7_2_6Panding_4',
    'xm7_2_6Panding_5',
    'xm7_2_6Panding_6',
    'xm7_2_6Panding_7',
    'xm7_2_6Panding_8',
    'xm7_2_6Panding_9',
    'xm7_2_7Panding_1',
    'xm7_2_7Panding_2',
    'xm7_2_7Panding_3',
    'xm7_2_7Panding_4',
    'xm8_1_1Panding_1',
    'xm8_1_1Panding_2',
    'xm8_1_1Panding_3',
    'xm8_1_1Panding_4',
    'xm8_1_1Panding_5',
    'xm8_1_1Panding_6',
    'xm8_1_1Panding_7',
    'xm8_1_1Panding_8',
    'xm8_1_1Panding_9',
    'xm8_1_1Panding_10',
    'xm8_1_2Panding_1',
    'xm8_1_2Panding_2',
    'xm8_1_2Panding_3',
    'xm8_1_2Panding_4',
    'xm8_1_2Panding_5',
    'xm8_1_2Panding_6',
    'xm8_1_2Panding_7',
    'xm8_1_2Panding_8',
    'xm8_1_3Panding_1',
    'xm8_1_3Panding_2',
    'xm8_1_3Panding_3',
    'xm8_1_3Panding_4',
    'xm8_2_1Panding_1',
    'xm8_2_1Panding_2',
    'xm8_2_1Panding_3',
    'xm8_2_1Panding_4',
    'xm8_2_1Panding_5',
    'xm8_2_1Panding_6',
    'xm8_2_1Panding_7',
    'xm8_2_1Panding_8',
    'xm8_2_1Panding_9',
    'xm8_2_2Panding_1',
    'xm8_2_2Panding_2',
    'xm8_2_2Panding_3',
    'xm8_2_2Panding_4',
    'xm8_2_3Panding_1',
    'xm8_2_3Panding_2',
    'xm8_2_3Panding_3',
    'xm8_2_3Panding_4',
    'xm8_2_3Panding_5',
    'xm8_2_3Panding_6',
    'xm8_2_3Panding_7',
    'xm8_2_3Panding_8',
    'xm8_2_3Panding_9',
    'xm8_2_3Panding_10',
    'xm8_2_3Panding_11',
    'xm8_2_3Panding_12',
    'xm8_2_3Panding_13',
    'xm8_2_3Panding_14',
    'xm8_2_4Panding_1',
    'xm8_2_4Panding_2',
    'xm8_2_4Panding_3',
    'xm8_2_4Panding_4',
    'xm8_2_4Panding_5',
    'xm8_2_4Panding_6',
    'xm8_2_4Panding_7',
    'xm8_2_5Panding_1',
    'xm8_2_5Panding_2',
    'xm8_2_5Panding_3',
    'xm8_2_5Panding_4',
    'xm8_2_6Panding_1',
    'xm8_2_6Panding_2',
    'xm9_1Panding_1',
    'xm9_1Panding_2',
    'xm9_1Panding_3',
    'xm9_1Panding_4',
    'xm9_1Panding_5',
    'xm9_2_1Panding_1',
    'xm9_2_1Panding_2',
    'xm9_2_2Panding_1',
    'xm9_2_2Panding_2',
    'xm9_3_1Panding_1',
    'xm9_3_1Panding_2',
    'xm9_3_1Panding_3',
    'xm9_3_2Panding_1',
    'xm9_3_2Panding_2',
    'xm9_4_1Panding_1',
    'xm9_4_1Panding_2',
    'xm9_4_1Panding_3',
    'xm9_4_1Panding_4',
    'xm9_4_2Panding_1',
    'xm9_4_2Panding_2',
    'xm9_4_2Panding_3',
    'xm9_4_2Panding_4',
    'xm9_4_3Panding_1',
    'xm9_4_3Panding_2',
    'xm9_4_3Panding_3',
    'xm9_4_3Panding_4',
    'xm9_4_4Panding_1',
    'xm9_4_4Panding_2',
    'xm9_4_4Panding_3',
    'xm9_4_4Panding_4',
    'xm9_5Panding_1',
    'xm9_5Panding_2',
    'xm9_5Panding_3',
    'xm9_5Panding_4',
    'xm9_5Panding_5',
    'xm9_5Panding_6',
    'xm9_5Panding_7',
    'xm9_5Panding_8',
    'xm9_5Panding_9',
    'xm9_5Panding_10',
    'xm9_5Panding_11',
    'xm9_6_1Panding_1',
    'xm9_6_1Panding_2',
    'xm9_6_2Panding_1',
    'xm9_6_2Panding_2',
    'xm9_6_2Panding_3',
    'xm9_6_3Panding_1',
    'xm9_6_3Panding_2',
    'xm9_6_3Panding_3',
    'xm9_6_4Panding_1',
    'xm9_6_4Panding_2',
    'xm9_6_4Panding_3',
    'xm9_6_4Panding_4',
    'xm9_6_5Panding_1',
    'xm9_6_5Panding_2',
    'xm9_7_1Panding_1',
    'xm9_7_1Panding_2',
    'xm9_7_1Panding_3',
    'xm9_7_1Panding_4',
    'xm9_7_1Panding_5',
    'xm9_7_1Panding_6',
    'xm9_7_1Panding_7',
    'xm9_7_1Panding_8',
    'xm9_7_1Panding_9',
    'xm9_7_1Panding_10',
    'xm9_7_2Panding_1',
    'xm9_7_2Panding_2',
    'xm9_8Panding_1',
    'xm9_8Panding_2',
    'xm9_8Panding_3',
    'xm9_8Panding_4',
    'xm9_8Panding_5',
    'xm9_8Panding_6',
    'xm10_1Panding_1',
    'xm10_1Panding_2',
    'xm10_1Panding_3',
    'xm10_1Panding_4',
    'xm10_1Panding_5',
    'xm10_2Panding_1',
    'xm10_2Panding_2',
    'xm10_2Panding_3',
    'xm10_2Panding_4',
    'xm10_2Panding_5',
    'xm10_2Panding_6',
    'xm10_2Panding_7',
    'xm10_3Panding_1',
    'xm10_3Panding_2',
    'xm10_4Panding_1',
    'xm10_4Panding_2',
    'xm10_5Panding_1',
    'xm10_5Panding_2',
    'xm10_5Panding_3',
    'xm10_5Panding_4',
    'xm10_5Panding_5',
    'xm10_5Panding_6',
    'xm10_5Panding_7',
    'xm10_5Panding_8',
    'xm10_5Panding_9',
    'xm10_5Panding_10',
    'xm11_1Panding_1',
    'xm11_1Panding_2',
    'xm11_1Panding_3',
    'xm11_1Panding_4',
    'xm11_2Panding_1',
    'xm11_2Panding_2',
    'xm11_2Panding_3',
    'xm11_3Panding_1',
    'xm11_3Panding_2',
    'xm11_3Panding_3',
    'xm12_1Panding_1',
    'xm12_1Panding_2',
    'xm12_1Panding_3',
    'xm12_1Panding_4',
    'xm12_2_1Panding_1',
    'xm12_2_1Panding_2',
    'xm12_2_2Panding_1',
    'xm12_2_2Panding_2',
    'xm12_2_2Panding_3',
    'xm12_2_2Panding_4',
    'xm12_3Panding_1',
    'xm12_3Panding_2',
    'xm12_3Panding_3',
    'xm13_1Panding_1',
    'xm13_1Panding_2',
    'xm13_2Panding_1',
    'xm13_2Panding_2',
    'xm13_2Panding_3',
    'xm13_3Panding_1',
    'xm13_3Panding_2',
    'xm2_1Panding',
    'xm2_2Panding',
    'xm3_1_1Panding',
    'xm3_1_2Panding',
    'xm3_2_1Panding',
    'xm3_2_2Panding',
    'xm3_2_3Panding',
    'xm3_2_4Panding',
    'xm4_1_1Panding',
    'xm4_1_2Panding',
    'xm4_2_1Panding',
    'xm4_2_2Panding',
    'xm4_3Panding',
    'xm5_1_1Panding',
    'xm5_1_2Panding',
    'xm5_2_1Panding',
    'xm5_2_2Panding',
    'xm5_3_1Panding',
    'xm5_3_2Panding',
    'xm5_4_1Panding',
    'xm5_4_2Panding',
    'xm5_5Panding',
    'xm6_1_1Panding',
    'xm6_1_2Panding',
    'xm6_1_3Panding',
    'xm6_1_4Panding',
    'xm6_2_1Panding',
    'xm6_2_2Panding',
    'xm7_1_1Panding',
    'xm7_1_2Panding',
    'xm7_1_3Panding',
    'xm7_1_4Panding',
    'xm7_1_5Panding',
    'xm7_1_6Panding',
    'xm7_2_1Panding',
    'xm7_2_2Panding',
    'xm7_2_3Panding',
    'xm7_2_4Panding',
    'xm7_2_5Panding',
    'xm7_2_6Panding',
    'xm7_2_7Panding',
    'xm8_1_1Panding',
    'xm8_1_2Panding',
    'xm8_1_3Panding',
    'xm8_2_1Panding',
    'xm8_2_2Panding',
    'xm8_2_3Panding',
    'xm8_2_4Panding',
    'xm8_2_5Panding',
    'xm8_2_6Panding',
    'xm9_1Panding',
    'xm9_2_1Panding',
    'xm9_2_2Panding',
    'xm9_3_1Panding',
    'xm9_3_2Panding',
    'xm9_4_1Panding',
    'xm9_4_2Panding',
    'xm9_4_3Panding',
    'xm9_4_4Panding',
    'xm9_5Panding',
    'xm9_6_1Panding',
    'xm9_6_2Panding',
    'xm9_6_3Panding',
    'xm9_6_4Panding',
    'xm9_6_5Panding',
    'xm9_7_1Panding',
    'xm9_7_2Panding',
    'xm9_8Panding',
    'xm10_1Panding',
    'xm10_2Panding',
    'xm10_3Panding',
    'xm10_4Panding',
    'xm10_5Panding',
    'xm11_1Panding',
    'xm11_2Panding',
    'xm11_3Panding',
    'xm12_1Panding',
    'xm12_2_1Panding',
    'xm12_2_2Panding',
    'xm12_3Panding',
    'xm13_1Panding',
    'xm13_2Panding',
    'xm13_3Panding',
  ]
  const formatDate = (date, all = false) => {
    let year = date.getFullYear().toString()
    let month =
      (date.getMonth() + 1).toString().length > 1
        ? (date.getMonth() + 1).toString()
        : '0' + (date.getMonth() + 1).toString()
    let day =
      date.getDate().toString().length > 1
        ? date.getDate().toString()
        : '0' + date.getDate().toString()
    let min =
      date.getMinutes().toString().length > 1
        ? date.getMinutes().toString()
        : '0' + date.getMinutes().toString()
    let hour =
      date.getHours().toString().length > 1
        ? date.getHours().toString()
        : '0' + date.getHours().toString()
    let second =
      date.getSeconds().toString().length > 1
        ? date.getSeconds().toString()
        : '0' + date.getSeconds().toString()
    let formatted_date = year + '-' + month + '-' + day
    if (all) formatted_date += '-' + hour + '-' + min + '-' + second
    return formatted_date
  }
  export default {
    name: 'Tree',
    components: {
      mypdfView,
      //VueOfficePdf,
    },
    data() {
      return {
        PS_JieLunDetail: '',
        drawer1: true,
        drawer: false,
        foujueBuhege: [],
        pandingBuhege: [],
        tableData: [],
        jielun: 'success',
        PS_DanWei: '',
        pdf_src: '',
        selectedItem: 'tab2',
        dataTime: '',
        dialogVisible: false, //弹出框
        ps_XiangMu: '',
        ps_XiangMu_Name: '',
        zhege: 0,
        zjibenhege: 0,
        zbuhege: 0,
        zbushiyong: 0,
        t_zhege: 0,
        t_zjibenhege: 0,
        t_zbuhege: 0,
        t_zbushiyong: 0,
        showpanding: false,
        showBuhege: false,
        hide_panding: false,

        xm_2JieDai: '',
        xm_3JieDai: '',
        xm_4JieDai: '',
        xm_5JieDai: '',
        xm_6JieDai: '',
        xm_7JieDai: '',
        xm_8JieDai: '',
        xm_9JieDai: '',
        xm_10JieDai: '',
        xm_11JieDai: '',
        xm_12JieDai: '',
        xm_13JieDai: '',

        xm2_1Panding_1: '',
        xm2_1Panding_2: '',
        xm2_1Panding_3: '',
        xm2_1Panding_4: '',
        xm2_2Panding_1: '',
        xm2_2Panding_2: '',
        xm2_2Panding_3: '',
        xm2_2Panding_4: '',
        xm2_2Panding_5: '',
        xm2_2Panding_6: '',
        xm3_1_1Panding_1: '',
        xm3_1_1Panding_2: '',
        xm3_1_1Panding_3: '',
        xm3_1_2Panding_1: '',
        xm3_1_2Panding_2: '',
        xm3_1_2Panding_3: '',
        xm3_1_2Panding_4: '',
        xm3_2_1Panding_1: '',
        xm3_2_1Panding_2: '',
        xm3_2_1Panding_3: '',
        xm3_2_1Panding_4: '',
        xm3_2_1Panding_5: '',
        xm3_2_1Panding_6: '',
        xm3_2_1Panding_7: '',
        xm3_2_1Panding_8: '',
        xm3_2_1Panding_9: '',
        xm3_2_2Panding_1: [,],
        xm3_2_2Panding_2: '',
        xm3_2_2Panding_3: '',
        xm3_2_2Panding_4: '',
        xm3_2_2Panding_5: '',
        xm3_2_2Panding_6: '',
        xm3_2_3Panding_1: [,],
        xm3_2_3Panding_2: '',
        xm3_2_3Panding_3: '',
        xm3_2_4Panding_1: '',
        xm3_2_4Panding_2: '',
        xm4_1_1Panding_1: '',
        xm4_1_1Panding_2: '',
        xm4_1_1Panding_3: '',
        xm4_1_1Panding_4: '',
        xm4_1_1Panding_5: '',
        xm4_1_1Panding_6: '',
        xm4_1_1Panding_7: [,],
        xm4_1_1Panding_8: '',
        xm4_1_2Panding_1: '',
        xm4_1_2Panding_2: '',
        xm4_2_1Panding_1: '',
        xm4_2_1Panding_2: '',
        xm4_2_1Panding_3: '',
        xm4_2_1Panding_4: '',
        xm4_2_1Panding_5: '',
        xm4_2_1Panding_6: '',
        xm4_2_1Panding_7: [,],
        xm4_2_1Panding_8: '',
        xm4_2_2Panding_1: '',
        xm4_2_2Panding_2: '',
        xm4_3Panding_1: [,],
        xm4_3Panding_2: '',
        xm4_3Panding_3: '',
        xm4_3Panding_4: '',
        xm4_3Panding_5: '',
        xm4_3Panding_6: '',
        xm4_3Panding_7: '',
        xm4_3Panding_8: '',
        xm4_3Panding_9: '',
        xm4_3Panding_10: '',
        xm4_3Panding_11: '',
        xm4_3Panding_12: '',
        xm5_1_1Panding_1: '',
        xm5_1_1Panding_2: '',
        xm5_1_1Panding_3: '',
        xm5_1_1Panding_4: '',
        xm5_1_2Panding_1: '',
        xm5_1_2Panding_2: '',
        xm5_1_2Panding_3: '',
        xm5_1_2Panding_4: '',
        xm5_1_2Panding_5: '',
        xm5_1_2Panding_6: '',
        xm5_1_2Panding_7: '',
        xm5_1_2Panding_8: '',
        xm5_2_1Panding_1: '',
        xm5_2_1Panding_2: '',
        xm5_2_1Panding_3: '',
        xm5_2_1Panding_4: [,],
        xm5_2_1Panding_5: '',
        xm5_2_1Panding_6: '',
        xm5_2_1Panding_7: '',
        xm5_2_1Panding_8: '',
        xm5_2_1Panding_9: '',
        xm5_2_1Panding_10: '',
        xm5_2_1Panding_11: '',
        xm5_2_1Panding_12: '',
        xm5_2_1Panding_13: [,],
        xm5_2_1Panding_14: '',
        xm5_2_1Panding_15: '',
        xm5_2_1Panding_16: '',
        xm5_2_1Panding_17: '',
        xm5_2_1Panding_18: '',
        xm5_2_1Panding_19: '',
        xm5_2_1Panding_20: '',
        xm5_2_2Panding_1: '',
        xm5_2_2Panding_2: '',
        xm5_2_2Panding_3: '',
        xm5_3_1Panding_1: '',
        xm5_3_1Panding_2: '',
        xm5_3_1Panding_3: '',
        xm5_3_1Panding_4: '',
        xm5_3_1Panding_5: '',
        xm5_3_1Panding_6: '',
        xm5_3_1Panding_7: '',
        xm5_3_2Panding_1: '',
        xm5_3_2Panding_2: '',
        xm5_3_2Panding_3: '',
        xm5_3_2Panding_4: [,],
        xm5_3_2Panding_5: '',
        xm5_3_2Panding_6: '',
        xm5_3_2Panding_7: '',
        xm5_4_1Panding_1: '',
        xm5_4_1Panding_2: '',
        xm5_4_1Panding_3: '',
        xm5_4_1Panding_4: '',
        xm5_4_1Panding_5: '',
        xm5_4_1Panding_6: '',
        xm5_4_1Panding_7: '',
        xm5_4_1Panding_8: '',
        xm5_4_1Panding_9: '',
        xm5_4_1Panding_10: '',
        xm5_4_1Panding_11: '',
        xm5_4_1Panding_12: '',
        xm5_4_1Panding_13: '',
        xm5_4_1Panding_14: '',
        xm5_4_2Panding_1: '',
        xm5_4_2Panding_2: '',
        xm5_4_2Panding_3: [,],
        xm5_4_2Panding_4: '',
        xm5_4_2Panding_5: '',
        xm5_4_2Panding_6: [,],
        xm5_4_2Panding_7: '',
        xm5_4_2Panding_8: '',
        xm5_4_2Panding_9: [,],
        xm5_4_2Panding_10: '',
        xm5_4_2Panding_11: '',
        xm5_5Panding_1: '',
        xm5_5Panding_2: '',
        xm5_5Panding_3: '',
        xm6_1_1Panding_1: '',
        xm6_1_1Panding_2: '',
        xm6_1_1Panding_3: '',
        xm6_1_1Panding_4: '',
        xm6_1_1Panding_5: '',
        xm6_1_2Panding_1: '',
        xm6_1_2Panding_2: '',
        xm6_1_2Panding_3: '',
        xm6_1_2Panding_4: '',
        xm6_1_2Panding_5: '',
        xm6_1_2Panding_6: '',
        xm6_1_2Panding_7: '',
        xm6_1_2Panding_8: '',
        xm6_1_2Panding_9: '',
        xm6_1_2Panding_10: '',
        xm6_1_3Panding_1: '',
        xm6_1_3Panding_2: '',
        xm6_1_3Panding_3: '',
        xm6_1_3Panding_4: '',
        xm6_1_3Panding_5: '',
        xm6_1_3Panding_6: '',
        xm6_1_4Panding_1: [,],
        xm6_1_4Panding_2: '',
        xm6_2_1Panding_1: '',
        xm6_2_1Panding_2: '',
        xm6_2_1Panding_3: '',
        xm6_2_1Panding_4: '',
        xm6_2_1Panding_5: '',
        xm6_2_1Panding_6: '',
        xm6_2_1Panding_7: '',
        xm6_2_1Panding_8: '',
        xm6_2_2Panding_1: [,],
        xm6_2_2Panding_2: '',
        xm6_2_2Panding_3: '',
        xm6_2_2Panding_4: '',
        xm6_2_2Panding_5: '',
        xm7_1_1Panding_1: '',
        xm7_1_1Panding_2: '',
        xm7_1_1Panding_3: '',
        xm7_1_1Panding_4: [,],
        xm7_1_1Panding_5: '',
        xm7_1_2Panding_1: '',
        xm7_1_2Panding_2: '',
        xm7_1_2Panding_3: '',
        xm7_1_2Panding_4: '',
        xm7_1_2Panding_5: '',
        xm7_1_2Panding_6: '',
        xm7_1_2Panding_7: '',
        xm7_1_2Panding_8: '',
        xm7_1_2Panding_9: '',
        xm7_1_2Panding_10: '',
        xm7_1_2Panding_11: '',
        xm7_1_2Panding_12: '',
        xm7_1_2Panding_13: '',
        xm7_1_2Panding_14: '',
        xm7_1_3Panding_1: '',
        xm7_1_3Panding_2: '',
        xm7_1_4Panding_1: '',
        xm7_1_4Panding_2: '',
        xm7_1_4Panding_3: '',
        xm7_1_4Panding_4: '',
        xm7_1_4Panding_5: '',
        xm7_1_4Panding_6: '',
        xm7_1_4Panding_7: '',
        xm7_1_4Panding_8: '',
        xm7_1_4Panding_9: '',
        xm7_1_4Panding_10: '',
        xm7_1_4Panding_11: '',
        xm7_1_5Panding_1: '',
        xm7_1_5Panding_2: '',
        xm7_1_5Panding_3: '',
        xm7_1_5Panding_4: '',
        xm7_1_5Panding_5: '',
        xm7_1_5Panding_6: '',
        xm7_1_5Panding_7: '',
        xm7_1_5Panding_8: '',
        xm7_1_5Panding_9: '',
        xm7_1_6Panding_1: '',
        xm7_1_6Panding_2: '',
        xm7_1_6Panding_3: '',
        xm7_1_6Panding_4: '',
        xm7_1_6Panding_5: '',
        xm7_1_6Panding_6: '',
        xm7_2_1Panding_1: '',
        xm7_2_1Panding_2: '',
        xm7_2_1Panding_3: '',
        xm7_2_1Panding_4: [,],
        xm7_2_1Panding_5: '',
        xm7_2_2Panding_1: '',
        xm7_2_2Panding_2: '',
        xm7_2_2Panding_3: '',
        xm7_2_2Panding_4: '',
        xm7_2_2Panding_5: '',
        xm7_2_2Panding_6: '',
        xm7_2_2Panding_7: '',
        xm7_2_2Panding_8: '',
        xm7_2_2Panding_9: '',
        xm7_2_2Panding_10: '',
        xm7_2_2Panding_11: '',
        xm7_2_2Panding_12: '',
        xm7_2_3Panding_1: '',
        xm7_2_3Panding_2: '',
        xm7_2_4Panding_1: '',
        xm7_2_4Panding_2: '',
        xm7_2_4Panding_3: '',
        xm7_2_4Panding_4: '',
        xm7_2_4Panding_5: '',
        xm7_2_4Panding_6: '',
        xm7_2_4Panding_7: '',
        xm7_2_4Panding_8: '',
        xm7_2_4Panding_9: '',
        xm7_2_4Panding_10: '',
        xm7_2_4Panding_11: '',
        xm7_2_5Panding_1: '',
        xm7_2_5Panding_2: '',
        xm7_2_5Panding_3: '',
        xm7_2_6Panding_1: '',
        xm7_2_6Panding_2: '',
        xm7_2_6Panding_3: '',
        xm7_2_6Panding_4: '',
        xm7_2_6Panding_5: '',
        xm7_2_6Panding_6: '',
        xm7_2_6Panding_7: '',
        xm7_2_6Panding_8: '',
        xm7_2_6Panding_9: '',
        xm7_2_7Panding_1: '',
        xm7_2_7Panding_2: '',
        xm7_2_7Panding_3: '',
        xm7_2_7Panding_4: '',
        xm8_1_1Panding_1: '',
        xm8_1_1Panding_2: '',
        xm8_1_1Panding_3: '',
        xm8_1_1Panding_4: '',
        xm8_1_1Panding_5: '',
        xm8_1_1Panding_6: '',
        xm8_1_1Panding_7: '',
        xm8_1_1Panding_8: '',
        xm8_1_1Panding_9: '',
        xm8_1_1Panding_10: '',
        xm8_1_2Panding_1: '',
        xm8_1_2Panding_2: '',
        xm8_1_2Panding_3: '',
        xm8_1_2Panding_4: '',
        xm8_1_2Panding_5: '',
        xm8_1_2Panding_6: '',
        xm8_1_2Panding_7: '',
        xm8_1_2Panding_8: '',
        xm8_1_3Panding_1: '',
        xm8_1_3Panding_2: '',
        xm8_1_3Panding_3: '',
        xm8_1_3Panding_4: '',
        xm8_2_1Panding_1: '',
        xm8_2_1Panding_2: '',
        xm8_2_1Panding_3: '',
        xm8_2_1Panding_4: '',
        xm8_2_1Panding_5: '',
        xm8_2_1Panding_6: '',
        xm8_2_1Panding_7: '',
        xm8_2_1Panding_8: [,],
        xm8_2_1Panding_9: '',
        xm8_2_2Panding_1: '',
        xm8_2_2Panding_2: '',
        xm8_2_2Panding_3: '',
        xm8_2_2Panding_4: '',
        xm8_2_3Panding_1: '',
        xm8_2_3Panding_2: '',
        xm8_2_3Panding_3: '',
        xm8_2_3Panding_4: '',
        xm8_2_3Panding_5: '',
        xm8_2_3Panding_6: '',
        xm8_2_3Panding_7: '',
        xm8_2_3Panding_8: '',
        xm8_2_3Panding_9: '',
        xm8_2_3Panding_10: '',
        xm8_2_3Panding_11: '',
        xm8_2_3Panding_12: '',
        xm8_2_3Panding_13: '',
        xm8_2_3Panding_14: '',
        xm8_2_4Panding_1: '',
        xm8_2_4Panding_2: [,],
        xm8_2_4Panding_3: '',
        xm8_2_4Panding_4: '',
        xm8_2_4Panding_5: '',
        xm8_2_4Panding_6: '',
        xm8_2_4Panding_7: '',
        xm8_2_5Panding_1: '',
        xm8_2_5Panding_2: '',
        xm8_2_5Panding_3: '',
        xm8_2_5Panding_4: '',
        xm8_2_6Panding_1: '',
        xm8_2_6Panding_2: '',
        xm9_1Panding_1: '',
        xm9_1Panding_2: '',
        xm9_1Panding_3: '',
        xm9_1Panding_4: [,],
        xm9_1Panding_5: '',
        xm9_2_1Panding_1: '',
        xm9_2_1Panding_2: '',
        xm9_2_2Panding_1: '',
        xm9_2_2Panding_2: '',
        xm9_3_1Panding_1: '',
        xm9_3_1Panding_2: '',
        xm9_3_1Panding_3: '',
        xm9_3_2Panding_1: '',
        xm9_3_2Panding_2: '',
        xm9_4_1Panding_1: '',
        xm9_4_1Panding_2: [,],
        xm9_4_1Panding_3: '',
        xm9_4_1Panding_4: '',
        xm9_4_2Panding_1: '',
        xm9_4_2Panding_2: [,],
        xm9_4_2Panding_3: '',
        xm9_4_2Panding_4: '',
        xm9_4_3Panding_1: '',
        xm9_4_3Panding_2: [,],
        xm9_4_3Panding_3: '',
        xm9_4_3Panding_4: '',
        xm9_4_4Panding_1: '',
        xm9_4_4Panding_2: [,],
        xm9_4_4Panding_3: '',
        xm9_4_4Panding_4: '',
        xm9_5Panding_1: '',
        xm9_5Panding_2: '',
        xm9_5Panding_3: '',
        xm9_5Panding_4: '',
        xm9_5Panding_5: '',
        xm9_5Panding_6: '',
        xm9_5Panding_7: '',
        xm9_5Panding_8: '',
        xm9_5Panding_9: '',
        xm9_5Panding_10: '',
        xm9_5Panding_11: '',
        xm9_6_1Panding_1: '',
        xm9_6_1Panding_2: '',
        xm9_6_2Panding_1: '',
        xm9_6_2Panding_2: '',
        xm9_6_2Panding_3: '',
        xm9_6_3Panding_1: '',
        xm9_6_3Panding_2: '',
        xm9_6_3Panding_3: '',
        xm9_6_4Panding_1: '',
        xm9_6_4Panding_2: '',
        xm9_6_4Panding_3: '',
        xm9_6_4Panding_4: '',
        xm9_6_5Panding_1: '',
        xm9_6_5Panding_2: '',
        xm9_7_1Panding_1: '',
        xm9_7_1Panding_2: '',
        xm9_7_1Panding_3: '',
        xm9_7_1Panding_4: '',
        xm9_7_1Panding_5: '',
        xm9_7_1Panding_6: '',
        xm9_7_1Panding_7: '',
        xm9_7_1Panding_8: '',
        xm9_7_1Panding_9: '',
        xm9_7_1Panding_10: '',
        xm9_7_2Panding_1: [,],
        xm9_7_2Panding_2: '',
        xm9_8Panding_1: '',
        xm9_8Panding_2: '',
        xm9_8Panding_3: '',
        xm9_8Panding_4: '',
        xm9_8Panding_5: '',
        xm9_8Panding_6: '',
        xm10_1Panding_1: '',
        xm10_1Panding_2: [,],
        xm10_1Panding_3: '',
        xm10_1Panding_4: '',
        xm10_1Panding_5: '',
        xm10_2Panding_1: '',
        xm10_2Panding_2: '',
        xm10_2Panding_3: '',
        xm10_2Panding_4: '',
        xm10_2Panding_5: '',
        xm10_2Panding_6: '',
        xm10_2Panding_7: '',
        xm10_3Panding_1: '',
        xm10_3Panding_2: '',
        xm10_4Panding_1: '',
        xm10_4Panding_2: '',
        xm10_5Panding_1: '',
        xm10_5Panding_2: '',
        xm10_5Panding_3: [,],
        xm10_5Panding_4: '',
        xm10_5Panding_5: '',
        xm10_5Panding_6: '',
        xm10_5Panding_7: '',
        xm10_5Panding_8: '',
        xm10_5Panding_9: '',
        xm10_5Panding_10: '',
        xm11_1Panding_1: '',
        xm11_1Panding_2: '',
        xm11_1Panding_3: '',
        xm11_1Panding_4: '',
        xm11_2Panding_1: '',
        xm11_2Panding_2: '',
        xm11_2Panding_3: '',
        xm11_3Panding_1: '',
        xm11_3Panding_2: '',
        xm11_3Panding_3: '',
        xm12_1Panding_1: '',
        xm12_1Panding_2: '',
        xm12_1Panding_3: '',
        xm12_1Panding_4: '',
        xm12_2_1Panding_1: '',
        xm12_2_1Panding_2: '',
        xm12_2_2Panding_1: '',
        xm12_2_2Panding_2: '',
        xm12_2_2Panding_3: '',
        xm12_2_2Panding_4: '',
        xm12_3Panding_1: '',
        xm12_3Panding_2: '',
        xm12_3Panding_3: '',
        xm13_1Panding_1: '',
        xm13_1Panding_2: '',
        xm13_2Panding_1: '',
        xm13_2Panding_2: '',
        xm13_2Panding_3: '',
        xm13_3Panding_1: ['01', ''],
        xm13_3Panding_2: '',
        xm2_1Panding: ['符合'],
        xm2_2Panding: ['符合'],
        xm3_1_1Panding: ['符合'],
        xm3_1_2Panding: ['符合'],
        xm3_2_1Panding: ['符合'],
        xm3_2_2Panding: ['符合'],
        xm3_2_3Panding: ['符合'],
        xm3_2_4Panding: ['符合'],
        xm4_1_1Panding: ['符合'],
        xm4_1_2Panding: ['符合'],
        xm4_2_1Panding: ['符合'],
        xm4_2_2Panding: ['符合'],
        xm4_3Panding: ['符合'],
        xm5_1_1Panding: ['符合'],
        xm5_1_2Panding: ['符合'],
        xm5_2_1Panding: ['符合'],
        xm5_2_2Panding: ['符合'],
        xm5_3_1Panding: ['符合'],
        xm5_3_2Panding: ['符合'],
        xm5_4_1Panding: ['符合'],
        xm5_4_2Panding: ['符合'],
        xm5_5Panding: ['符合'],
        xm6_1_1Panding: ['符合'],
        xm6_1_2Panding: ['符合'],
        xm6_1_3Panding: ['符合'],
        xm6_1_4Panding: ['符合'],
        xm6_2_1Panding: ['符合'],
        xm6_2_2Panding: ['符合'],
        xm7_1_1Panding: ['符合'],
        xm7_1_2Panding: ['符合'],
        xm7_1_3Panding: ['符合'],
        xm7_1_4Panding: ['符合'],
        xm7_1_5Panding: ['符合'],
        xm7_1_6Panding: ['符合'],
        xm7_2_1Panding: ['符合'],
        xm7_2_2Panding: ['符合'],
        xm7_2_3Panding: ['符合'],
        xm7_2_4Panding: ['符合'],
        xm7_2_5Panding: ['符合'],
        xm7_2_6Panding: ['符合'],
        xm7_2_7Panding: ['符合'],
        xm8_1_1Panding: ['符合'],
        xm8_1_2Panding: ['符合'],
        xm8_1_3Panding: ['符合'],
        xm8_2_1Panding: ['符合'],
        xm8_2_2Panding: ['符合'],
        xm8_2_3Panding: ['符合'],
        xm8_2_4Panding: ['符合'],
        xm8_2_5Panding: ['符合'],
        xm8_2_6Panding: ['符合'],
        xm9_1Panding: ['符合'],
        xm9_2_1Panding: ['符合'],
        xm9_2_2Panding: ['符合'],
        xm9_3_1Panding: ['符合'],
        xm9_3_2Panding: ['符合'],
        xm9_4_1Panding: ['符合'],
        xm9_4_2Panding: ['符合'],
        xm9_4_3Panding: ['符合'],
        xm9_4_4Panding: ['符合'],
        xm9_5Panding: ['符合'],
        xm9_6_1Panding: ['符合'],
        xm9_6_2Panding: ['符合'],
        xm9_6_3Panding: ['符合'],
        xm9_6_4Panding: ['符合'],
        xm9_6_5Panding: ['符合'],
        xm9_7_1Panding: ['符合'],
        xm9_7_2Panding: ['符合'],
        xm9_8Panding: ['符合'],
        xm10_1Panding: ['符合'],
        xm10_2Panding: ['符合'],
        xm10_3Panding: ['符合'],
        xm10_4Panding: ['符合'],
        xm10_5Panding: ['符合'],
        xm11_1Panding: ['符合'],
        xm11_2Panding: ['符合'],
        xm11_3Panding: ['符合'],
        xm12_1Panding: ['符合'],
        xm12_2_1Panding: ['符合'],
        xm12_2_2Panding: ['符合'],
        xm12_3Panding: ['符合'],
        xm13_1Panding: ['符合'],
        xm13_2Panding: ['符合'],
        xm13_3Panding: ['符合'],
        twoOptions: TwoOptions,
        threeOptions0: ThreeOptions0,
        threeOptions: ThreeOptions,
        fourOptions: FourOptions,
        xm2Foujue: 0,
        xm0Foujue: 0,
        xm1Foujue: 0,
        xm3Foujue: 0,
        xm4Foujue: 0,
        xm5Foujue: 0,
        xm6Foujue: 0,
        xm7Foujue: 0,
        xm8Foujue: 0,
        xm9Foujue: 0,
        xm10Foujue: 0,
        xm11Foujue: 0,
        xm12Foujue: 0,
        xm13Foujue: 0,
        xm3_1Foujue: 0,
        xm3_2Foujue: 0,
        xm4_1Foujue: 0,
        xm4_2Foujue: 0,
        xm5_1Foujue: 0,
        xm5_2Foujue: 0,
        xm5_3Foujue: 0,
        xm5_4Foujue: 0,
        xm6_1Foujue: 0,
        xm6_2Foujue: 0,
        xm7_1Foujue: 0,
        xm7_2Foujue: 0,
        xm8_1Foujue: 0,
        xm8_2Foujue: 0,
        xm9_2Foujue: 0,
        xm9_3Foujue: 0,
        xm9_4Foujue: 0,
        xm9_6Foujue: 0,
        xm9_7Foujue: 0,
        xm12_2Foujue: 0,
        xm0Count: 0,
        xm1Count: 0,
        xm2Count: 0,
        xm3Count: 0,
        xm4Count: 0,
        xm5Count: 0,
        xm6Count: 0,
        xm7Count: 0,
        xm8Count: 0,
        xm9Count: 0,
        xm10Count: 0,
        xm11Count: 0,
        xm12Count: 0,
        xm13Count: 0,
        xm3_1Count: 0,
        xm3_2Count: 0,
        xm4_1Count: 0,
        xm4_2Count: 0,
        xm5_1Count: 0,
        xm5_2Count: 0,
        xm5_3Count: 0,
        xm5_4Count: 0,
        xm6_1Count: 0,
        xm6_2Count: 0,
        xm7_1Count: 0,
        xm7_2Count: 0,
        xm8_1Count: 0,
        xm8_2Count: 0,
        xm9_2Count: 0,
        xm9_3Count: 0,
        xm9_4Count: 0,
        xm9_6Count: 0,
        xm9_7Count: 0,
        xm12_2Count: 0,

        xm2Kaohe: 0,
        buhegeBaogao: [],
        allPanding: [],
        pandingObj: {
          xm_count: 0,
          xm_hege: 0,
          xm_buhege: 0,
          xm_jiben: 0,
          xm_bushiyong: 0,
          fj_count: 0,
          fj_hege: 0,
          fj_buhege: 0,
          fj_bushiyong: 0,
          pd_count: 0,
          pd_hege: 0,
          pd_jiben: 0,
          pd_buhege: 0,
          pd_bushiyong: 0,
          xm_bilv: 0.0,
          xm_jielun: '',
        },
        selectedIds: [],
        kaohe: 0,
        foujue: 0,
        defaultExpanDetail: true,
        defaultExpendedAll: true,
        showSelec: true,
        selectCount: 0,
        selectCount_0: 0,
        input: '',
        treeData: '',
        tempTreeData: '',
        searchBarFixed: true,
        tipsBarFixed: true,
        value1: '',
        dialogTitle: '添加节点',
        treeFlag: 0,
        treeDialogVisible: false,
        treeForm: {
          id: '',
          name: '',
        },
        dsiplayMode: '',
        radio: '',
        textarea1: '',
        isShow: true,
        defaultCheckedKeys: [],
        defaultExpendedKeys: [],
        isIndeterminate: false,
        checkAll: false,
        checkNodeKeys: [],
        checkNodeNames: [],
        checkNodes: [],
        id1: false,
        id2: false,
        id3: false,
        id4: false,
        id5: false,
        id6: false,
        id7: false,
        id8: false,
        id9: false,
        id10: false,
        id11: false,
        id12: false,
        id13: false,
        id14: false,
        id15: false,
        id16: false,
        id17: false,
        id18: false,
        id19: false,
        id20: false,
        id21: false,
        id22: false,
        id23: false,
        id24: false,
        id25: false,
        id26: false,
        id27: false,
        id28: false,
        id29: false,
        id30: false,
        id31: false,
        id32: false,
        id33: false,
        id34: false,
        id35: false,
        id36: false,
        id37: false,
        id38: false,
        id39: false,
        id40: false,
        id41: false,
        id42: false,
        id43: false,
        id44: false,
        id45: false,
        id46: false,
        id47: false,
        id48: false,
        id49: false,
        id50: false,
        id51: false,
        id52: false,
        id53: false,
        id54: false,
        id55: false,
        id56: false,
        id57: false,
        id58: false,
        id59: false,
        id60: false,
        id61: false,
        id62: false,
        id63: false,
        id64: false,
        id65: false,
        id66: false,
        id67: false,
        id68: false,
        id69: false,
        id70: false,
        id71: false,
        id72: false,
        id73: false,
        id74: false,
        id75: false,
        id76: false,
        id77: false,
        id78: false,
        id79: false,
        id80: false,
        id81: false,
        id82: false,
        id83: false,
        id84: false,
        id85: false,
        id86: false,
        id87: false,
        id88: false,
        id89: false,
        id90: false,
        id91: false,
        id92: false,
        id93: false,
        id94: false,
        id95: false,
        id96: false,
        id97: false,
        id98: false,
        id99: false,
        id100: false,
        id101: false,
        id102: false,
        id103: false,
        id104: false,
        id105: false,
        id106: false,
        id107: false,
        id108: false,
        id109: false,
        id110: false,
        id111: false,
        id112: false,
        id113: false,
        id114: false,
        id115: false,
        xm2hege: 0,
        xm3hege: 0,
        xm3_1hege: 0,
        xm3_2hege: 0,
        xm4hege: 0,
        xm4_1hege: 0,
        xm4_2hege: 0,
        xm5hege: 0,
        xm5_1hege: 0,
        xm5_2hege: 0,
        xm5_3hege: 0,
        xm5_4hege: 0,
        xm6hege: 0,
        xm6_1hege: 0,
        xm6_2hege: 0,
        xm7hege: 0,
        xm7_1hege: 0,
        xm7_2hege: 0,
        xm8hege: 0,
        xm8_1hege: 0,
        xm8_2hege: 0,
        xm9hege: 0,
        xm9_2hege: 0,
        xm9_3hege: 0,
        xm9_4hege: 0,
        xm9_6hege: 0,
        xm9_7hege: 0,
        xm10hege: 0,
        xm11hege: 0,
        xm12hege: 0,
        xm12_2hege: 0,
        xm13hege: 0,
        xm2buhege: 0,
        xm3buhege: 0,
        xm3_1buhege: 0,
        xm3_2buhege: 0,
        xm4buhege: 0,
        xm4_1buhege: 0,
        xm4_2buhege: 0,
        xm5buhege: 0,
        xm5_1buhege: 0,
        xm5_2buhege: 0,
        xm5_3buhege: 0,
        xm5_4buhege: 0,
        xm6buhege: 0,
        xm6_1buhege: 0,
        xm6_2buhege: 0,
        xm7buhege: 0,
        xm7_1buhege: 0,
        xm7_2buhege: 0,
        xm8buhege: 0,
        xm8_1buhege: 0,
        xm8_2buhege: 0,
        xm9buhege: 0,
        xm9_2buhege: 0,
        xm9_3buhege: 0,
        xm9_4buhege: 0,
        xm9_6buhege: 0,
        xm9_7buhege: 0,
        xm10buhege: 0,
        xm11buhege: 0,
        xm12buhege: 0,
        xm12_2buhege: 0,
        xm13buhege: 0,
        xm2weipan: 0,
        xm3weipan: 0,
        xm3_1weipan: 0,
        xm3_2weipan: 0,
        xm4weipan: 0,
        xm4_1weipan: 0,
        xm4_2weipan: 0,
        xm5weipan: 0,
        xm5_1weipan: 0,
        xm5_2weipan: 0,
        xm5_3weipan: 0,
        xm5_4weipan: 0,
        xm6weipan: 0,
        xm6_1weipan: 0,
        xm6_2weipan: 0,
        xm7weipan: 0,
        xm7_1weipan: 0,
        xm7_2weipan: 0,
        xm8weipan: 0,
        xm8_1weipan: 0,
        xm8_2weipan: 0,
        xm9weipan: 0,
        xm9_2weipan: 0,
        xm9_3weipan: 0,
        xm9_4weipan: 0,
        xm9_6weipan: 0,
        xm9_7weipan: 0,
        xm10weipan: 0,
        xm11weipan: 0,
        xm12weipan: 0,
        xm12_2weipan: 0,
        xm13weipan: 0,
        xm2jibenhege: 0,
        xm3jibenhege: 0,
        xm3_1jibenhege: 0,
        xm3_2jibenhege: 0,
        xm4jibenhege: 0,
        xm4_1jibenhege: 0,
        xm4_2jibenhege: 0,
        xm5jibenhege: 0,
        xm5_1jibenhege: 0,
        xm5_2jibenhege: 0,
        xm5_3jibenhege: 0,
        xm5_4jibenhege: 0,
        xm6jibenhege: 0,
        xm6_1jibenhege: 0,
        xm6_2jibenhege: 0,
        xm7jibenhege: 0,
        xm7_1jibenhege: 0,
        xm7_2jibenhege: 0,
        xm8jibenhege: 0,
        xm8_1jibenhege: 0,
        xm8_2jibenhege: 0,
        xm9jibenhege: 0,
        xm9_2jibenhege: 0,
        xm9_3jibenhege: 0,
        xm9_4jibenhege: 0,
        xm9_6jibenhege: 0,
        xm9_7jibenhege: 0,
        xm10jibenhege: 0,
        xm11jibenhege: 0,
        xm12jibenhege: 0,
        xm12_2jibenhege: 0,
        xm13jibenhege: 0,
        xm2bushiyong: 0,
        xm3bushiyong: 0,
        xm3_1bushiyong: 0,
        xm3_2bushiyong: 0,
        xm4bushiyong: 0,
        xm4_1bushiyong: 0,
        xm4_2bushiyong: 0,
        xm5bushiyong: 0,
        xm5_1bushiyong: 0,
        xm5_2bushiyong: 0,
        xm5_3bushiyong: 0,
        xm5_4bushiyong: 0,
        xm6bushiyong: 0,
        xm6_1bushiyong: 0,
        xm6_2bushiyong: 0,
        xm7bushiyong: 0,
        xm7_1bushiyong: 0,
        xm7_2bushiyong: 0,
        xm8bushiyong: 0,
        xm8_1bushiyong: 0,
        xm8_2bushiyong: 0,
        xm9bushiyong: 0,
        xm9_2bushiyong: 0,
        xm9_3bushiyong: 0,
        xm9_4bushiyong: 0,
        xm9_6bushiyong: 0,
        xm9_7bushiyong: 0,
        xm10bushiyong: 0,
        xm11bushiyong: 0,
        xm12bushiyong: 0,
        xm12_2bushiyong: 0,
        xm13bushiyong: 0,
        filterText: '',
        buhegeBaoGaoFile: '',
        baogaoLink: false,
        PS_ID: this.$store.state.detail.PS_ID,
        RW_PS_ID: this.$store.state.detail.PS_ID,
        data2: [],
        ShowBHG: false,
        defaultProps: {
          children: 'children',
          label: 'name',
        },
        pickerOptions: {
          disabledDate(time) {
            return time.getTime() > Date.now()
          },
          shortcuts: [
            {
              text: '今天',
              onClick(picker) {
                picker.$emit('pick', new Date())
              },
            },
            {
              text: '昨天',
              onClick(picker) {
                const date = new Date()
                date.setTime(date.getTime() - 3600 * 1000 * 24)
                picker.$emit('pick', date)
              },
            },
            {
              text: '一周前',
              onClick(picker) {
                const date = new Date()
                date.setTime(date.getTime() - 3600 * 1000 * 24 * 7)
                picker.$emit('pick', date)
              },
            },
          ],
        },
      }
    },
    computed: {
      // 计算属性的 getter
      reversedMessage: function () {
        // `this` 指向 vm 实例
        return this.selectedIds.thisin('')
      },
      'this.PS_ID': function () {
        // `this` 指向 vm 实例
        return this.$store.state.detail.PS_ID
      },
    },
    watch: {
      checkNodeKeys(val) {
        this.ps_XiangMu = this.checkNodeKeys
      },

      '$store.state.detail.PS_ID'() {
        this.PS_ID = this.$store.state.detail.PS_ID
      },
      filterText(val) {
        this.$refs.demoTree.filter(val)
      },
      selectCount(val) {
        this.selectCount_0 = val
      },
      //监听selectedIds数组的变化
      //计算每个项目有多少考核项、多少否决项
      selectedIds(newIds, oldIds) {
        //监测selectIds,选中项数组数量的变化,动态修改每项相应的数量。
        let quanbu = [
          //全部的考核项,共83项
          ['2.1', '2.2'],
          ['3.1.1', '3.1.2', '3.2.1', '3.2.2', '3.2.3', '3.2.4'],
          ['4.1.1', '4.1.2', '4.2.1', '4.2.2', '4.3'],
          [
            '5.1.1',
            '5.1.2',
            '5.2.1',
            '5.2.2',
            '5.3.1',
            '5.3.2',
            '5.4.1',
            '5.4.2',
            '5.5',
          ],
          ['6.1.1', '6.1.2', '6.1.3', '6.1.4', '6.2.1', '6.2.2'],
          [
            '7.1.1',
            '7.1.2',
            '7.1.3',
            '7.1.4',
            '7.1.5',
            '7.1.6',
            '7.2.1',
            '7.2.2',
            '7.2.3',
            '7.2.4',
            '7.2.5',
            '7.2.6',
            '7.2.7',
          ],
          [
            '8.1.1',
            '8.1.2',
            '8.1.3',
            '8.2.1',
            '8.2.2',
            '8.2.3',
            '8.2.4',
            '8.2.5',
            '8.2.6',
          ],
          [
            '9.1',
            '9.2.1',
            '9.2.2',
            '9.3.1',
            '9.3.2',
            '9.4.1',
            '9.4.2',
            '9.4.3',
            '9.4.4',
            '9.5',
            '9.6.1',
            '9.6.2',
            '9.6.3',
            '9.6.4',
            '9.6.5',
            '9.7.1',
            '9.7.2',
            '9.8',
          ],
          ['10.1', '10.2', '10.3', '10.4', '10.5'],
          ['11.1', '11.2', '11.3'],
          ['12.1', '12.2.1', '12.2.2', '12.3'],
          ['13.1', '13.2', '13.3'],
        ]
        let fouju = [
          //全部的否决项,共七项
          ['2.1', '2.2'],
          [],
          [],
          [],
          [],
          [],
          [],
          ['8.1.1', '8.1.2'],
          ['9.7.1'],
          [],
          ['11.2'],
          [],
          ['13.3'],
        ]
        let secondFouju = ['8.1.1', '8.1.2', '9.7.1']
        let secondIds = [
          '3.1',
          '3.2',
          '4.1',
          '4.2',
          '5.1',
          '5.2',
          '5.3',
          '5.4',
          '6.1',
          '6.2',
          '7.1',
          '7.2',
          '8.1',
          '8.2',
          '9.2',
          '9.3',
          '9.4',
          '9.6',
          '9.7',
          '12.2',
        ]
        let b = []
        let c = []
        quanbu.map((quanbuItem, _index) => {
          b = []
          let _count = 0
          quanbuItem.map((item) => {
            this.selectedIds.find((i) => {
              item == i ? _count++ : ''
            })
          })
          this[`xm${_index + 2}Count`] = _count
        })
        fouju.map((foujueItem, _index) => {
          c = []
          foujueItem.map((item) => {
            this.selectedIds.find((i) => item == i)
              ? c.push(this.selectedIds.find((i) => item == i))
              : ''
          })
          this[`xm${_index + 2}Foujue`] = c.length
        })
        //计算二级判定项下面的数量
        secondIds.map((item, _index) => {
          let _count = 0
          let _fjcount = 0
          let pattern = new RegExp('^' + item + '[^]*')
          this.selectedIds.find((i) => {
            if (-1 != i.search(pattern)) {
              _count++
              if (secondFouju.indexOf(i) != -1) _fjcount++
            }
          })
          this[`xm${item.replace('.', '_')}Count`] = _count
          this[`xm${item.replace('.', '_')}Foujue`] = _fjcount
          // console.log('item, _index')
          // console.log(item, _index)
        })
      },
    },
    //页面加
    mounted() {
      if (this.$store.state.detail.PS_ID == '') {
        //如果没有选择评审任务就返回到首页
        console.log(this.$route.path)
        this.delTabsBar(this.$route)
        //console.log(this.delTabsBar(this.$route.path))
        this.$router.push('/')
        this.$alert('请选择或新建评审任务', '提示', {
          confirmButtonText: '确定',
          callback: (action) => {
            //_that.$baseMessage('请选择或新建评审任务', 'error')
          },
        })
      }
      window.addEventListener('scroll', this.handleScroll)
      //初始化页面选中项
      this.$nextTick(() => {
        this.getTreeListFuc(1).then(() => {
          this.fetchData().then(() => {
            this.setCheckedKeys()
          })
        })

        this.danxiang_checkChange()

        //this.checkNodes = this.$refs.demoTree.getCheckedNodes()
      })
      this.getCheckedNodes()
    },

    methods: {
      alertClose() {
        this.showpanding = false
      },
      stopstop() {},
      handleAdd() {
        console.log(this.pdf_src)
        if (this.pdf_src != '') this.$refs['edit'].showEdit(this.pdf_src)
      },
      handleClick(tab, event) {},
      ...mapActions({
        delTabsBar: 'tabsBar/delRoute',
      }),
      reload() {
        this.fetchData().then(() => {
          this.setCheckedKeys()
          console.log('dddddddddd')
          this.showSelected()
          console.log('eeeeeeee')
        })
      },
      XianSibufuhe() {
        if (this.ShowBHG) {
          for (let i = 1; i < 116; i++) {
            if (this.$refs['id' + i]) this.$refs['id' + i].style.display = ''
          }
        } else {
          let optinArray = []
          this.tempTreeData.forEach((item) => {
            item.children.forEach((subItem) => {
              if (subItem.children.length == 0)
                optinArray.push(subItem.id + ',' + item.id + ',' + '0')
              else
                subItem.children.forEach((thirdItem) => {
                  if (thirdItem.children.length == 0)
                    optinArray.push(
                      thirdItem.id + ',' + subItem.id + ',' + item.id
                    )
                })
            })
          })
          console.log('optinArray')
          console.log(optinArray)

          for (let i = 1; i < 116; i++) {
            if (this.$refs['id' + i])
              this.$refs['id' + i].style.display = 'none'
          }
          this.buhegeBaogao.map((bhg_item) => {
            console.log(bhg_item.id)
            console.log(bhg_item)
            if (this.$refs['id' + bhg_item.id])
              this.$refs['id' + bhg_item.id].style.display = ''
            optinArray.map((item) => {
              let _temArray = item.split(',')
              if (bhg_item.id == _temArray[0]) {
                if (this.$refs['id' + _temArray[1]])
                  this.$refs['id' + _temArray[1]].style.display = ''
                if (this.$refs['id' + _temArray[2]])
                  this.$refs['id' + _temArray[2]].style.display = ''
              }
            })
          })

          // let count = (item.BHG_ID.match(/\./g) || []).length
          // console.log(count)
          // if (count > 1) {
          //   if (this.$refs['id' + (item.id - 1)])
          //     this.$refs['id' + (item.id - 1)].style.display = ''
          // }
        }
        this.ShowBHG = !this.ShowBHG
      },
      async fetchData() {
        try {
          // GET request for remote image in node.js
          this.PS_ID = this.$store.state.detail.PS_ID
          this.PS_DanWei = this.$store.state.detail.PS_DanWei
          const response = await axios({
            method: 'post',
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getRenWuDetail', //请求地址
            responseType: 'stream',
            data: JSON.stringify({ ids: this.PS_ID }), //表单序列化
          })
          console.log(response)
          console.log(response.data)
          const { count, Data } = eval(response.data)
          console.log(count + '--------' + Data)
          this.buhegeBaoGaoFile = response.data.Data[0].PS_File
          this.pdf_src = this.buhegeBaoGaoFile.replace('doc', 'pdf')
          this.ps_XiangMu = response.data.Data[0].PS_XiangMu
          console.log('this.ps_XiangMu')
          console.log(this.ps_XiangMu)

          if (this.buhegeBaoGaoFile && this.buhegeBaoGaoFile != '')
            this.baogaoLink = true

          for (var i = 0; i < PANDINGLIST.length; i++) {
            this[PANDINGLIST[i]] =
              response.data.Data[0].PS_Detail[PANDINGLIST[i]] == '符合'
                ? ['符合']
                : response.data.Data[0].PS_Detail[PANDINGLIST[i]] == '不符'
                ? ['不符']
                : response.data.Data[0].PS_Detail[PANDINGLIST[i]] == '基本'
                ? ['基本']
                : response.data.Data[0].PS_Detail[PANDINGLIST[i]] == '不适用'
                ? ['不适用']
                : response.data.Data[0].PS_Detail[PANDINGLIST[i]]
          }

          console.log('----------------')

          this['xm3_2_2Panding_1'] =
            response.data.Data[0].PS_Detail['xm3_2_2Panding_1'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm3_2_2Panding_1'].split(',')
          // console.log(this['xm3_2_2Panding_1'])
          // console.log(response.data.Data[0].PS_Detail['xm3_2_2Panding_1'])

          this['xm3_2_3Panding_1'] =
            response.data.Data[0].PS_Detail['xm3_2_3Panding_1'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm3_2_3Panding_1'].split(',')
          this['xm4_1_1Panding_7'] =
            response.data.Data[0].PS_Detail['xm4_1_1Panding_7'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm4_1_1Panding_7'].split(',')
          this['xm4_2_1Panding_7'] =
            response.data.Data[0].PS_Detail['xm4_2_1Panding_7'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm4_2_1Panding_7'].split(',')
          this['xm4_3Panding_1'] =
            response.data.Data[0].PS_Detail['xm4_3Panding_1'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm4_3Panding_1'].split(',')
          this['xm5_2_1Panding_4'] =
            response.data.Data[0].PS_Detail['xm5_2_1Panding_4'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm5_2_1Panding_4'].split(',')
          this['xm5_2_1Panding_13'] =
            response.data.Data[0].PS_Detail['xm5_2_1Panding_13'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm5_2_1Panding_13'].split(',')
          this['xm5_3_2Panding_4'] =
            response.data.Data[0].PS_Detail['xm5_3_2Panding_4'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm5_3_2Panding_4'].split(',')
          this['xm5_4_2Panding_3'] =
            response.data.Data[0].PS_Detail['xm5_4_2Panding_3'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm5_4_2Panding_3'].split(',')
          this['xm5_4_2Panding_6'] =
            response.data.Data[0].PS_Detail['xm5_4_2Panding_6'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm5_4_2Panding_6'].split(',')
          this['xm5_4_2Panding_9'] =
            response.data.Data[0].PS_Detail['xm5_4_2Panding_9'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm5_4_2Panding_9'].split(',')
          this['xm6_1_4Panding_1'] =
            response.data.Data[0].PS_Detail['xm6_1_4Panding_1'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm6_1_4Panding_1'].split(',')
          this['xm6_2_2Panding_1'] =
            response.data.Data[0].PS_Detail['xm6_2_2Panding_1'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm6_2_2Panding_1'].split(',')
          this['xm7_1_1Panding_4'] =
            response.data.Data[0].PS_Detail['xm7_1_1Panding_4'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm7_1_1Panding_4'].split(',')
          this['xm7_2_1Panding_4'] =
            response.data.Data[0].PS_Detail['xm7_2_1Panding_4'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm7_2_1Panding_4'].split(',')
          this['xm8_2_1Panding_8'] =
            response.data.Data[0].PS_Detail['xm8_2_1Panding_8'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm8_2_1Panding_8'].split(',')
          this['xm8_2_4Panding_2'] =
            response.data.Data[0].PS_Detail['xm8_2_4Panding_2'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm8_2_4Panding_2'].split(',')
          this['xm9_1Panding_4'] =
            response.data.Data[0].PS_Detail['xm9_1Panding_4'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm9_1Panding_4'].split(',')
          this['xm9_4_1Panding_2'] =
            response.data.Data[0].PS_Detail['xm9_4_1Panding_2'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm9_4_1Panding_2'].split(',')
          this['xm9_4_2Panding_2'] =
            response.data.Data[0].PS_Detail['xm9_4_2Panding_2'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm9_4_2Panding_2'].split(',')
          this['xm9_4_3Panding_2'] =
            response.data.Data[0].PS_Detail['xm9_4_3Panding_2'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm9_4_3Panding_2'].split(',')
          this['xm9_4_4Panding_2'] =
            response.data.Data[0].PS_Detail['xm9_4_4Panding_2'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm9_4_4Panding_2'].split(',')
          this['xm9_7_2Panding_1'] =
            response.data.Data[0].PS_Detail['xm9_7_2Panding_1'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm9_7_2Panding_1'].split(',')
          this['xm10_1Panding_2'] =
            response.data.Data[0].PS_Detail['xm10_1Panding_2'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm10_1Panding_2'].split(',')
          this['xm10_5Panding_3'] =
            response.data.Data[0].PS_Detail['xm10_5Panding_3'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm10_5Panding_3'].split(',')
          this['xm13_3Panding_1'] =
            response.data.Data[0].PS_Detail['xm13_3Panding_1'] == ''
              ? [,]
              : response.data.Data[0].PS_Detail['xm13_3Panding_1'].split(',')
          //                console.log(response.data.Data[0].PS_Detail.xm2_1Panding)
          //  response.data.Data[0].PS_Detail.xm2_1Panding.toString() == '符合'
          //           ? console.log('ee')
          //           : console.log('222')

          this.showSelected()
        } catch (error) {
          console.error(error)
        }
      },
      dateChangebirthday(val) {
        console.log(val)
        this.xm3_2_3Panding_2 = val
        console.log(this.xm3_2_3Panding_2)
      },
      fetchData000() {
        console.log('dddddd')
        const _that = this
        _that.PS_ID = _that.$store.state.detail.PS_ID
        _that.RW_PS_ID = _that.PS_ID
        console.log(_that.PS_ID)
        if (_that.PS_ID != '') {
          let resultList = ''
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getRenWuDetail', //请求地址
            data: JSON.stringify({ ids: _that.PS_ID }), //表单序列化
            success: function (result) {
              //成功
              const { cout, Data } = result
              console.log('Data')
              console.log(Data)
              console.log(Data[0].PS_Detail)
              if (Data[0].PS_Detail != '') {
                for (var i = 0; i < PANDINGLIST.length; i++)
                  _that[PANDINGLIST[i]] =
                    Data[0].PS_Detail[PANDINGLIST[i]].toString()
                _that.$message({
                  type: 'success',
                  message: '导入成功!',
                })
              } else
                _that.$message({
                  type: 'success',
                  message: '无数据!',
                })
            },
            error: function (result) {
              const { cout, Data } = result
              console.log('Data!!!')
              console.log(result.responseText)
              console.log(JSON.parse(result.responseText))
              _that.$baseMessage(result.responseText, 'error')
            },
          })
        } else {
          _that.$alert('请选择或新建评审任务', '提示', {
            confirmButtonText: '确定',
            callback: (action) => {
              //_that.$baseMessage('请选择或新建评审任务', 'error')
            },
          })
          _that.RW_PS_ID = '暂时未载入数据，请注意保存！'
        }
        setTimeout(() => {
          _that.listLoading = false
        }, 300)
        //_that = null
      },
      handleClose() {},
      test() {
        this.dialogVisible = true
      },
      beifen() {
        let saveObj = {}
        let _dataTime =
          formatDate(new Date()) +
          new Date().getHours() +
          '-' +
          new Date().getMinutes()
        for (var i = 0; i < PANDINGLIST.length; i++)
          saveObj[PANDINGLIST[i]] = this[PANDINGLIST[i]].toString()
        localStorage.setItem(_dataTime, JSON.stringify(saveObj))
      },
      dateChange() {
        let _dataTime = formatDate(new Date(this.dataTime))
        var data = JSON.parse(localStorage.getItem(_dataTime))
        if (data != null) {
          //console.log(localStorage.getItem('saveObj'))
          this.$message({
            message: '恭喜你，找到数据，点击导入数据按钮载入！',
            type: 'success',
          })
        }
        //console.log(localStorage.getItem('saveObj'))
        else
          this.$message({
            message: _dataTime + '暂无数据！',
            type: 'erro',
          })
      },
      daoruData() {
        var date = new Date()
        let _dataTime = formatDate(date)
        if (this.dataTime != '') _dataTime = formatDate(new Date(this.dataTime))
        var data = JSON.parse(localStorage.getItem(_dataTime))
        if (data != null) {
          this.$confirm('导入数据将覆盖当前数据, 是否继续?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
          })
            .then(() => {
              this.beifen()
              for (var i = 0; i < PANDINGLIST.length; i++)
                this[PANDINGLIST[i]] = data[PANDINGLIST[i]].toString()
              this.$message({
                type: 'success',
                message: '导入成功!',
              })
            })
            .catch(() => {
              this.$message({
                type: 'info',
                message: '已取消导入',
              })
            })
        } else {
          this.$message({
            message: _dataTime + '无数据！',
            type: 'error',
          })
        }
      },
      saveData() {
        this.beifen()
        const _that = this
        _that.ps_XiangMu = this.$refs.demoTree.getCheckedKeys().join(',')
        console.log(_that.ps_XiangMu)
        const saveObj = {}
        for (var i = 0; i < PANDINGLIST.length; i++)
          saveObj[PANDINGLIST[i]] = this[PANDINGLIST[i]].toString()
        saveObj.xm_2JieDai = this.xm_2JieDai
        saveObj.xm_3JieDai = this.xm_3JieDai
        saveObj.xm_4JieDai = this.xm_4JieDai
        saveObj.xm_5JieDai = this.xm_5JieDai
        saveObj.xm_6JieDai = this.xm_6JieDai
        saveObj.xm_7JieDai = this.xm_7JieDai
        saveObj.xm_8JieDai = this.xm_8JieDai
        saveObj.xm_9JieDai = this.xm_9JieDai
        saveObj.xm_10JieDai = this.xm_10JieDai
        saveObj.xm_11JieDai = this.xm_11JieDai
        saveObj.xm_12JieDai = this.xm_12JieDai
        saveObj.xm_13JieDai = this.xm_13JieDai
        this.PS_ID = this.$store.state.detail.PS_ID
        this.RW_PS_ID = this.PS_ID
        console.log(this.PS_ID)
        if (this.PS_ID != '') {
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=saveRenWuDetail', //请求地址
            data: JSON.stringify({
              ids: _that.PS_ID,
              PS_XiangMu: _that.ps_XiangMu,
              postObj: saveObj,
            }), //表单序列化
            success: function (result) {},
            error: function (result) {
              console.log(result.responseText)
              _that.$baseMessage(result.responseText, 'success')
            },
          })
        } else {
          var date = new Date()
          let _dataTime = formatDate(date)
          if (this.dataTime != '')
            _dataTime = formatDate(new Date(this.dataTime))
          var data = JSON.parse(localStorage.getItem(_dataTime))
          let message = '创建成功！'
          console.log(this.dataTime)
          if (data != null) {
            this.$jj_alert({
              type: 'alert', //弹窗的类型有alert和sheet
              width: '50%', //设置弹窗的宽度
              height: '70%', //设置弹窗的宽度
              padding: '20px 30px', //设置内容的上下左右偏移
              maskColor: 'rgba(0, 0, 0, 0.6)', //遮罩层的背景颜色
              touchClose: true, //点击背景图层，是否关闭弹框
              showClose: true, //是否显示右上角的关闭按钮
              title: '提示', //标题
              titleStyle: {
                color: '#fb2408',
              }, //标题的样式
              message: _dataTime + '数据已存在，保存将覆盖原数据，请慎重！！！', //内容
              messageStyle: {
                'justify-content': 'left',
                display: 'flex',
                color: 'red',
                'text-align': 'left',
              }, //内容的样式
              btns: [
                {
                  title: '确认', //按钮文本
                  activeBackground: '#2A8AFF', //按钮激活背景色
                  activeColor: '#fff', //按钮激活的字体颜色
                  click: () => {
                    localStorage.setItem(_dataTime, JSON.stringify(saveObj))
                    //console.log(localStorage.getItem('saveObj'))
                    this.$message({
                      message: '恭喜你，修改成功！',
                      type: 'success',
                    })
                  },
                },
                {
                  title: '取消', //按钮文本
                  activeBackground: '#2A8AFF', //按钮激活背景色
                  activeColor: '#fff', //按钮激活的字体颜色
                  click: () => {
                    this.$message({
                      message: '已取消',
                      type: 'warning',
                    })
                  },
                },
              ],
            })
          } else {
            localStorage.setItem(_dataTime, JSON.stringify(saveObj))
            //console.log(localStorage.getItem('saveObj'))
            this.$message({
              message: _dataTime + '恭喜你，创建成功！',
              type: 'success',
            })
          }
          // this.$store.dispatch('detail/setPS_ID', this.$store.state.detail.PS_ID)
          // console.log(this.$store.state.detail.PS_ID)
          this.ExportData(
            formatDate(new Date(), true) + '.txt',
            JSON.stringify(saveObj)
          )
          this.RW_PS_ID = '暂时未载入数据，请注意保存！'
          _that.$baseMessage('未选择或新建评审任务', 'error')
        }
        setTimeout(() => {
          _that.listLoading = false
        }, 300)
      },
      ExportData(filename, filecontent) {
        //定义文件内容，类型必须为Blob 否则createObjectURL会报错
        let content = new Blob([filecontent])
        //生成url对象
        let urlObject = window.URL || window.webkitURL || window
        let url = urlObject.createObjectURL(content)
        //生成<a></a>DOM元素
        let el = document.createElement('a')
        //链接赋值
        el.href = url
        el.download = filename
        //必须点击否则不会下载
        el.click()
        //移除链接释放资源
        urlObject.revokeObjectURL(url)
      },

      qinchu() {
        for (var i = 0; i < PANDINGLIST.length; i++) {
          var name = '.' + PANDINGLIST[i]
          $(name).parent().css('background-color', '').css('border', '')
        }
      },
      jiaoyan() {
        for (var i = 0; i < PANDINGLIST.length; i++) {
          if (this[PANDINGLIST[i]].toString() == '') {
            var name = '.' + PANDINGLIST[i]
            $(name)
              .parent()
              .css('background-color', '#bdbcbc')
              .css('border', '1px dashed #dcdfe6')
          }
        }
      },
      baogaoDownload() {
        window.location.href = this.buhegeBaoGaoFile
      },

      baogao() {
        this.getCheckedNodes()
        const postObj = {}
        for (var i = 0; i < PANDINGLIST.length; i++)
          postObj[PANDINGLIST[i]] = this[PANDINGLIST[i]].toString()
        postObj.xm_BianHao = this.PS_ID
        postObj.xm_ChangJia = this.$store.state.detail.PS_DanWei
        postObj.xm_PingShenZhu = this.$store.state.detail.PS_RenYuan
        postObj.xm_StartTime = this.$store.state.detail.PS_RiQiStart
        postObj.xm_EndTime = this.$store.state.detail.PS_RiQiEnd

        postObj.xm_2JieDai = this.xm_2JieDai
        postObj.xm_3JieDai = this.xm_3JieDai
        postObj.xm_4JieDai = this.xm_4JieDai
        postObj.xm_5JieDai = this.xm_5JieDai
        postObj.xm_6JieDai = this.xm_6JieDai
        postObj.xm_7JieDai = this.xm_7JieDai
        postObj.xm_8JieDai = this.xm_8JieDai
        postObj.xm_9JieDai = this.xm_9JieDai
        postObj.xm_10JieDai = this.xm_10JieDai
        postObj.xm_11JieDai = this.xm_11JieDai
        postObj.xm_12JieDai = this.xm_12JieDai
        postObj.xm_13JieDai = this.xm_13JieDai

        console.log('baogao')
        const loading = this.$loading({
          lock: true,
          text: '拼命生成评审报告中。。。。。',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.8)',
        })
        var that = this
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=shengchengBaogao', //请求地址
          data: JSON.stringify({
            ids: this.PS_ID,
            postObj: postObj,
            PS_JieLunDetail: this.PS_JieLunDetail,
            PS_XiangMu: this.ps_XiangMu,
          }), //表单序列化
          success: function (result) {
            //成功
            console.log('生成success成功！！')
            console.log(result)

            setTimeout(() => {
              that.$message({
                type: 'success',
                message: '生成成功!点击下载报告下载！',
              })
              that.baogaoLink = true
              that.buhegeBaoGaoFile = result.responseText
              setTimeout(() => loading.close(), 1000)
              that.pdf_src = that.buhegeBaoGaoFile.replace('doc', 'pdf')
              //window.location.href = this.buhegeBaoGaoFile
            }, 600)
          },
          error: function (result) {
            console.log('生成erro成功！！')
            setTimeout(() => {
              that.$message({
                type: 'success',
                message: '生成成功!点击下载报告下载！',
              })
              console.log(result)
              that.baogaoLink = true
              that.buhegeBaoGaoFile = result.responseText
              setTimeout(() => loading.close(), 1000)
              that.pdf_src = that.buhegeBaoGaoFile.replace('doc', 'pdf')
              //window.location.href = this.buhegeBaoGaoFile
            }, 600)
          },
        })
      },
      danxiang_checkChange() {
        $('p .is-checked .el-radio__label').textContent == '是'
      },
      // showPanding() {
      //   let _aFirst
      //   let _bFirst
      //   let _cFirst
      //   let _dFirst
      //   let _eFirst
      //   let _fFirst
      //   let _tobj = {}
      //   let _aObj = []
      //   let _myid
      //   let tempTreeData = this.tempTreeData
      //   console.log(tempTreeData)
      //   let _firsthegePanding = 0
      //   let _firstbuhegePanding = 0
      //   let _firstjibenhegePanding = 0
      //   let _firstbushiyongPanding = 0
      //   let _firstweiPanding = 0
      //   for (let i = 0; i < tempTreeData.length; i++) {
      //     //第一层循环，level=1,parent = 0 ,t
      //     _aFirst = tempTreeData[i].parentId
      //     _bFirst = tempTreeData[i].id
      //     console.log(_aFirst, _bFirst)
      //     if (tempTreeData[i].children.length > 0) {
      //       //第二层循环，level=2
      //       let _secondArray = tempTreeData[i].children
      //       let _secondhegePanding = 0
      //       let _secondbuhegePanding = 0
      //       let _secondjibenhegePanding = 0
      //       let _secondbushiyongPanding = 0
      //       let _secondweiPanding = 0
      //       for (let j = 0; j < _secondArray.length; j++) {
      //         _cFirst = _secondArray[j].parentId
      //         _dFirst = _secondArray[j].id
      //         console.log(_cFirst, _dFirst)

      //         let hegePanding = 0
      //         let buhegePanding = 0
      //         let jibenhegePanding = 0
      //         let bushiyongPanding = 0
      //         let weiPanding = 0
      //         ///如果有三级子项目
      //         if (_secondArray[j].children.length > 0) {
      //           let _thirdArray = _secondArray[j].children
      //           for (let t = 0; t < _thirdArray.length; t++) {
      //             _eFirst = _thirdArray[t].parentId
      //             _fFirst = _thirdArray[t].id
      //             console.log(_eFirst, _fFirst)

      //             let _thiredPanding =
      //               $(`.id${_fFirst} .is-checked input`) != null &&
      //               $(`.id${_fFirst} .is-checked input`).length > 0
      //                 ? $(`.id${_fFirst} .is-checked input`)[0].value
      //                 : ''
      //             console.log(_thiredPanding)

      //             switch (_thiredPanding) {
      //               case '符合':
      //                 hegePanding = 1
      //                 _secondhegePanding++
      //                 break
      //               case '不符合':
      //                 buhegePanding = 1
      //                 _secondbuhegePanding++
      //                 break
      //               case '基本符合':
      //                 jibenhegePanding = 1
      //                 _secondjibenhegePanding++
      //                 break
      //               case '不适用':
      //                 bushiyongPanding = 1
      //                 _secondbushiyongPanding++
      //                 break
      //               default:
      //                 weiPanding = 1
      //                 _secondweiPanding++
      //                 break
      //             }
      //             console.log(_thiredPanding)

      //             _tobj = {
      //               id: _fFirst,
      //               level: _thirdArray[t].rank,
      //               parent: _eFirst,
      //               superparent: _cFirst,
      //               topparent: '0',
      //               value: _thirdArray[t].value,
      //               children: _thirdArray[t].children.length,
      //               hegePanding: _secondhegePanding,
      //               jibenhegePanding: _secondjibenhegePanding,
      //               buhegePanding: _secondbuhegePanding,
      //               bushiyongPanding: _secondbushiyongPanding,
      //               weiPanding: _secondweiPanding,
      //             }
      //             _aObj.push(_tobj)
      //           }

      //           _tobj = {
      //             //二级项目
      //             id: _dFirst,
      //             level: _secondArray[j].rank,
      //             parent: _cFirst,
      //             superparent: _aFirst,
      //             topparent: '0',
      //             value: _secondArray[j].value,
      //             children: _secondArray[j].children.length,
      //             hegePanding: hegePanding,
      //             jibenhegePanding: jibenhegePanding,
      //             buhegePanding: buhegePanding,
      //             bushiyongPanding: buhegePanding,
      //             weiPanding: weiPanding,
      //           }
      //           _aObj.push(_tobj)
      //         } else {
      //           _secondhegePanding = 0
      //           _secondbuhegePanding = 0
      //           _secondjibenhegePanding = 0
      //           _secondbushiyongPanding = 0
      //           _secondweiPanding = 0
      //           //没有三级子项目
      //           let _thiredPanding =
      //             $(`.id${_dFirst} .is-checked input`) != null &&
      //             $(`.id${_dFirst} .is-checked input`).length > 0
      //               ? $(`.id${_dFirst} .is-checked input`)[0].value
      //               : ''
      //           console.log(_thiredPanding)

      //           switch (_thiredPanding) {
      //             case '符合':
      //               _secondhegePanding = 1
      //               break
      //             case '不符合':
      //               _secondbuhegePanding = 1
      //               break
      //             case '基本符合':
      //               _secondjibenhegePanding = 1
      //               break
      //             case '不适用':
      //               _secondbushiyongPanding = 1
      //               break
      //             default:
      //               _secondweiPanding = 1
      //               break
      //           }
      //           _firsthegePanding += _secondhegePanding
      //           _firstbuhegePanding += _secondbuhegePanding
      //           _firstjibenhegePanding += _secondjibenhegePanding
      //           _firstbushiyongPanding += _secondbushiyongPanding
      //           _firstweiPanding += _secondweiPanding
      //           _tobj = {
      //             //二级项目
      //             id: _dFirst,
      //             level: _secondArray[j].rank,
      //             parent: _bFirst,
      //             superparent: _aFirst,
      //             topparent: '0',
      //             value: _secondArray[j].value,
      //             children: '0',
      //             hegePanding: _secondhegePanding,
      //             buhegePanding: _secondbuhegePanding,
      //             jibenhegePanding: _secondjibenhegePanding,
      //             bushiyongPanding: _secondbushiyongPanding,
      //             weiPanding: _secondweiPanding,
      //           }
      //           _aObj.push(_tobj)
      //         }
      //       }
      //     }
      //     _tobj = {
      //       //一级项目
      //       id: _bFirst,
      //       level: tempTreeData[i].rank,
      //       parent: _aFirst,
      //       superparent: '0',
      //       topparent: '0',
      //       value: tempTreeData[i].value,
      //       children: tempTreeData[i].children.length,
      //       hegePanding: _firsthegePanding,
      //       buhegePanding: _firstbuhegePanding,
      //       jibenhegePanding: _firstjibenhegePanding,
      //       bushiyongPanding: _firstbushiyongPanding,
      //       weiPanding: _firstweiPanding,
      //     }
      //     _aObj.push(_tobj)
      //   }
      //   console.log('********')
      //   console.log(_aObj)
      // },
      showPanding() {
        this.showpanding = true
        this.pandingObj.xm_count = 0
        this.pandingObj.xm_buhege = 0
        this.pandingObj.xm_hege = 0
        this.pandingObj.xm_bushiyong = 0
        this.pandingObj.xm_jiben = 0
        this.pandingObj.fj_count = 0
        this.pandingObj.fj_buhege = 0
        this.pandingObj.fj_hege = 0
        this.pandingObj.fj_bushiyong = 0
        this.pandingObj.pd_count = 0
        this.pandingObj.pd_hege = 0
        this.pandingObj.pd_buhege = 0
        this.pandingObj.pd_jiben = 0
        this.pandingObj.pd_buhege = 0
        this.pandingObj.xm_bilv = 0.0
        this.pandingObj.xm_jielun = ''
        this.showBuhege = !this.showBuhege
        this.zhege = 0
        this.zjibenhege = 0
        this.zbuhege = 0
        this.zbushiyong = 0
        let [
          _item1,
          _item2,
          _item3,
          _item4,
          _item5,
          _item6,
          _item7,
          _item8,
          _item9,
          _item10,
          _item11,
          _item12,
        ] = this.tempTreeData
        let _objArray = [
          //临时对象列表
          _item1,
          _item2,
          _item3,
          _item4,
          _item5,
          _item6,
          _item7,
          _item8,
          _item9,
          _item10,
          _item11,
          _item12,
        ]

        _objArray.forEach((item) => {
          this._sumary(item)
          console.log('this.item')
          console.log(item)
          // console.log('this.allPanding')
          // console.log(this.allPanding)
          // console.log('this.buhegeBaogao')
          // console.log(this.buhegeBaogao)
          this.zhege += 0 - 0 + this.t_zhege
          this.zbuhege += 0 - 0 + this.t_zbuhege
          this.zjibenhege += 0 - 0 + this.t_zjibenhege
          this.zbushiyong += 0 - 0 + this.t_zbushiyong
        })
        console.log('++++++++++++++++++')
        console.log(this.zhege)
        console.log(this.zbuhege)
        console.log(this.zjibenhege)
        console.log(this.zbushiyong)
        console.log(this.allPanding)
        this.allPanding.forEach((item) => {
          this.pandingObj.xm_count++
          if (
            ['13.3', '2.1', '8.1.1', '8.1.2', '9.7.1', '11.2', '2.2'].indexOf(
              item.value
            ) != -1
          ) {
            this.pandingObj.fj_count++ //否决项数量
            item.BHG_Type == '符合'
              ? this.pandingObj.fj_hege++
              : item.BHG_Type == '不符'
              ? this.pandingObj.fj_buhege++
              : this.pandingObj.fj_bushiyong++
          } else {
            this.pandingObj.pd_count++ //判定项数量
            item.BHG_Type == '符合'
              ? this.pandingObj.pd_hege++
              : item.BHG_Type == '不符'
              ? this.pandingObj.pd_buhege++
              : item.BHG_Type == '基本'
              ? this.pandingObj.pd_jiben++
              : this.pandingObj.pd_bushiyong++
          }
          console.log(
            item.value +
              '******' +
              item.BHG_Type +
              '*****' +
              this.pandingObj.pd_jiben
          )
        })
        this.pandingObj.xm_buhege +=
          0 - 0 + this.pandingObj.fj_buhege + this.pandingObj.pd_buhege
        this.pandingObj.xm_jiben = this.pandingObj.pd_jiben
        this.pandingObj.xm_hege +=
          0 - 0 + this.pandingObj.fj_hege + this.pandingObj.pd_hege
        this.pandingObj.xm_bushiyong +=
          0 - 0 + this.pandingObj.fj_bushiyong + this.pandingObj.pd_bushiyong
        console.log(this.pandingObj.xm_buhege)
        console.log(this.pandingObj.xm_jiben)
        console.log(this.pandingObj.fj_hege)
        console.log(this.pandingObj.fj_bushiyong)
        this.pandingObj.xm_bilv =
          (this.pandingObj.xm_jiben * 0.33333 - 0 + this.pandingObj.xm_buhege) /
          this.pandingObj.xm_count.toFixed(2)
        if (this.pandingObj.fj_buhege == 0) {
          this.pandingObj.xm_jielun =
            this.pandingObj.xm_bilv > 0.2
              ? 'D级不合格'
              : this.pandingObj.xm_bilv > 0.1
              ? 'C级合格'
              : this.pandingObj.xm_bilv > 0.05
              ? 'B级合格'
              : 'A级合格'
        } else {
          this.pandingObj.xm_jielun = '不合格'
        }
        if (this.pandingObj.xm_jielun.indexOf('不') != -1)
          this.jielun = 'danger'
        if (this.pandingObj.xm_jielun.indexOf('C') != -1)
          this.jielun = 'warning'
        console.log('this.pandingObj')
        console.log(this.pandingObj)
        this.pandingBuhege = []
        this.foujueBuhege = []

        this.buhegeBaogao.map((item) => {
          if (
            ['13.3', '2.1', '8.1.1', '8.1.2', '9.7.1', '11.2', '2.2'].indexOf(
              item.value
            ) == -1
          )
            this.pandingBuhege.push({ value: item.value, name: item.BHG_ID })
          else this.foujueBuhege.push({ value: item.value, name: item.BHG_ID })
        })
        console.log('pandingBuhege')
        console.log(this.pandingBuhege)
        console.log(this.foujueBuhege)
        let _pdcount =
          this.pandingObj.pd_hege -
          0 +
          this.pandingObj.pd_buhege -
          0 +
          this.pandingObj.pd_jiben -
          0 +
          this.pandingObj.pd_bushiyong

        this.tableData = [
          {
            type: '否决项',
            fuhe: this.pandingObj.fj_hege,
            bufuhe: this.pandingObj.fj_buhege,
            jibenfuhe: 0,
            bushiyong: 0,
            count: this.pandingObj.fj_hege - 0 + this.pandingObj.fj_buhege,
            buhegeXian: this.foujueBuhege,
          },
          {
            type: '判定项',
            fuhe: this.pandingObj.pd_hege,
            bufuhe: this.pandingObj.pd_buhege,
            jibenfuhe: this.pandingObj.pd_jiben,
            bushiyong: this.pandingObj.pd_bushiyong,
            count: _pdcount,
            buhegeXian: this.pandingBuhege,
          },
          {
            type: '合计',
            fuhe: this.pandingObj.xm_hege,
            bufuhe: this.pandingObj.xm_buhege,
            jibenfuhe: this.pandingObj.xm_jiben,
            bushiyong: this.pandingObj.xm_bushiyong,
            count:
              this.pandingObj.xm_hege -
              0 +
              this.pandingObj.xm_buhege -
              0 +
              this.pandingObj.xm_jiben -
              0 +
              this.pandingObj.xm_bushiyong,
            buhegeXian: [],
          },
        ]
        this.PS_JieLunDetail = `本次工厂评审共有否决项 ${
          this.pandingObj.fj_hege - 0 + this.pandingObj.fj_buhege
        } 项，考核项${_pdcount}项。其中，否决项<span style="color:red;font-weight:bold;"> ${
          this.pandingObj.fj_buhege
        } </span>项不符合，考核项<span style="color:red;font-weight:bold;"> ${
          this.pandingObj.pd_buhege
        } </span>项不符合、考核项 ${
          this.pandingObj.pd_jiben
        } 基本符合。根据矿用产品安全标志工厂评审判定规则，本次评审结论为：<span style="color:red;font-weight:bold;"> ${
          this.pandingObj.xm_jielun
        }</span>。`
      },
      //单项判定
      setMealSelect(e, obj, idNum) {
        let firstLevel = [] //一级列表
        let secondLevel = [] //二级列表
        let thirdLevel = [] //三级列表
        let _pandingArray = [] //判定项列表
        let _obj = {} //临时对象变量
        let _firstParent = 'id0'
        let _secondParent = ''
        let _thirdParent = ''
        let _id = obj.replace('xm', '')
        let _index = _id.split('_')[0] - 2
        //element-u中Checkbox 多选框只能选择一个
        // 截取数组的最后一位,并从新赋值
        this[`${obj}anding`] = this[`${obj}anding`].slice(-1)
        let _pattern = /\d{1,2}(_\d{1,2}){1,2}/g
        let match = obj.match(_pattern).join().replace('_', '.')
        if (this[`${obj}anding`][0] == undefined) {
          console.log(this[`${obj}anding`][0])
          $(event.target)
            .parents('.danxiang')
            .parent()
            .parent()
            .css('border', '2px solid crimson')
            .css('background', 'crimson')
            .css('padding', '20px 0px')
          console.log($(event.target).parents('.danxiang').parent())
        } else {
          $(event.target)
            .parents('.danxiang')
            .parent()
            .parent()
            .css('border', '0px')
            .css('background', '')
            .css('padding', '')
          if (this[`${obj}anding`][0] == '不符')
            $(event.target)
              .siblings()
              .css('background', '#FF0033')
              .css('border-color', '#FF0033')
          if (this[`${obj}anding`][0] == '基本')
            $(event.target)
              .siblings()
              .css('background', '#9933FF')
              .css('border-color', '#9933FF')

          if (this[`${obj}anding`][0] == '不适用')
            $(event.target)
              .siblings()
              .css('background', '#333300')
              .css('border-color', '#333300')
        }
        let [
          _item1,
          _item2,
          _item3,
          _item4,
          _item5,
          _item6,
          _item7,
          _item8,
          _item9,
          _item10,
          _item11,
          _item12,
        ] = this.tempTreeData
        let _objArray = [
          //临时对象列表
          _item1,
          _item2,
          _item3,
          _item4,
          _item5,
          _item6,
          _item7,
          _item8,
          _item9,
          _item10,
          _item11,
          _item12,
        ]
        let _item = _objArray[_index]
        setTimeout(() => {
          this._sumary(_item)
          console.log('你好!')
        }, 5)
        // setTimeout(() => {
        //   this.showPanding()
        //   console.log('你好!')
        // }, 5)
      },
      _sumary(_item) {
        // 使用箭头语法的匿名回调函数。

        // let _index
        // _objArray.forEach((item, index) => {
        //   item.children.forEach((sumItem) => {
        //     if (sumItem.children.length > 0)
        //       sumItem.children.forEach((thirdItem) => {
        //         thirdItem.id == _id ? (_index = index) : ''
        //       })
        //     sumItem.id == _id ? (_index = index) : ''
        //   })
        // })
        //对每一大项进行小结
        let foujueXian = [
          '13.3',
          '2.1',
          '8.1.1',
          '8.1.2',
          '9.7.1',
          '11.2',
          '2.2',
        ]
        let foujue_hege_1 = 0
        let foujue_buhege_1 = 0
        let foujue_bushiyong_1 = 0
        let foujue_hege_2 = 0
        let foujue_buhege_2 = 0
        let foujue_bushiyong_2 = 0
        let foujue_hege_3 = 0
        let foujue_buhege_3 = 0
        let foujue_bushiyong_3 = 0
        let _buhegeArray = []
        let _zhege = 0
        let _zbuhege = 0
        let _zjibenhege = 0
        let _zbushiyong = 0
        let _firsthegePanding = 0
        let _firstbuhegePanding = 0
        let _firstjibenhegePanding = 0
        let _firstbushiyongPanding = 0
        let _firstweiPanding = 0
        let _secondhegePanding = 0
        let _secondbuhegePanding = 0
        let _secondjibenhegePanding = 0
        let _secondbushiyongPanding = 0
        let _secondweiPanding = 0
        let hegePanding = 0
        let buhegePanding = 0
        let jibenhegePanding = 0
        let bushiyongPanding = 0
        let weiPanding = 0
        _item.children.forEach((sumItem, _index) => {
          _secondhegePanding = 0
          _secondbuhegePanding = 0
          _secondjibenhegePanding = 0
          _secondbushiyongPanding = 0
          _secondweiPanding = 0
          if (sumItem.children.length > 0) {
            sumItem.children.forEach((thirdItem, __index) => {
              hegePanding = 0
              buhegePanding = 0
              jibenhegePanding = 0
              bushiyongPanding = 0
              weiPanding = 0
              let _thirdPanding =
                $(`.id${thirdItem.id} .is-checked input`) != null &&
                $(`.id${thirdItem.id} .is-checked input`).length > 0
                  ? $(`.id${thirdItem.id} .is-checked input`)[0].value
                  : '未判定'
              switch (_thirdPanding) {
                case '符合':
                  hegePanding = 1
                  let _tempJiben_000 = {
                    BHG_ID: thirdItem.text,
                    id: thirdItem.id,
                    value: thirdItem.value,
                    BHG_Type: '符合',
                    BHG_ShiShi: '',
                    BHG_ZhengGai: '',
                    isEdit: false,
                    isAdd: true,
                  }
                  this.allPanding.findIndex(
                    (item) => item.id == thirdItem.id
                  ) == -1
                    ? this.allPanding.push(_tempJiben_000)
                    : ''
                  break
                case '不符':
                  buhegePanding = 1
                  let _tempJiben_00 = {
                    BHG_ID: thirdItem.text,
                    id: thirdItem.id,
                    value: thirdItem.value,
                    BHG_Type: '不符',
                    BHG_ShiShi: '',
                    BHG_ZhengGai: '',
                    isEdit: false,
                    isAdd: true,
                  }
                  this.buhegeBaogao.findIndex(
                    (item) => item.id == thirdItem.id
                  ) == -1
                    ? this.buhegeBaogao.push(_tempJiben_00)
                    : ''
                  this.allPanding.findIndex(
                    (item) => item.id == thirdItem.id
                  ) == -1
                    ? this.allPanding.push(_tempJiben_00)
                    : ''
                  break
                case '基本':
                  jibenhegePanding = 1
                  let _tempJiben_01 = {
                    BHG_ID: thirdItem.text,
                    id: thirdItem.id,
                    value: thirdItem.value,
                    BHG_Type: '基本',
                    BHG_ShiShi: '',
                    BHG_ZhengGai: '',
                    isEdit: false,
                  }
                  this.buhegeBaogao.findIndex(
                    (item) => item.id == thirdItem.id
                  ) == -1
                    ? this.buhegeBaogao.push(_tempJiben_01)
                    : ''
                  this.allPanding.findIndex(
                    (item) => item.id == thirdItem.id
                  ) == -1
                    ? this.allPanding.push(_tempJiben_01)
                    : ''
                  break
                case '不适用':
                  bushiyongPanding = 1
                  let _tempJiben_001 = {
                    BHG_ID: thirdItem.text,
                    id: thirdItem.id,
                    value: thirdItem.value,
                    BHG_Type: '不适用',
                    BHG_ShiShi: '',
                    BHG_ZhengGai: '',
                    isEdit: false,
                  }
                  this.allPanding.findIndex(
                    (item) => item.id == thirdItem.id
                  ) == -1
                    ? this.allPanding.push(_tempJiben_001)
                    : ''
                  break
                default:
                  weiPanding = 1
                  break
              }
              // console.log(
              //   '三级项目判定' +
              //     '-' +
              //     thirdItem.id +
              //     '-' +
              //     thirdItem.name +
              //     '-' +
              //     __index +
              //     ',' +
              //     _thirdPanding
              // )
              console.log(_buhegeArray)

              _secondhegePanding += hegePanding
              _secondbuhegePanding += buhegePanding
              _secondjibenhegePanding += jibenhegePanding
              _secondbushiyongPanding += bushiyongPanding
              _secondweiPanding += weiPanding

              _zhege += hegePanding
              _zjibenhege += jibenhegePanding
              _zbuhege += buhegePanding
              _zbushiyong += bushiyongPanding
            })
            this[`xm${sumItem.value.replace('.', '_')}hege`] =
              _secondhegePanding
            this[`xm${sumItem.value.replace('.', '_')}buhege`] =
              _secondbuhegePanding
            this[`xm${sumItem.value.replace('.', '_')}jibenhege`] =
              _secondjibenhegePanding
            this[`xm${sumItem.value.replace('.', '_')}bushiyong`] =
              _secondbushiyongPanding
            this[`xm${sumItem.value.replace('.', '_')}weipan`] =
              _secondweiPanding
          } else {
            let _secondPanding =
              $(`.id${sumItem.id} .is-checked input`) != null &&
              $(`.id${sumItem.id} .is-checked input`).length > 0
                ? $(`.id${sumItem.id} .is-checked input`)[0].value
                : ''
            switch (_secondPanding) {
              case '符合':
                _secondhegePanding = 1
                let _tempJiben_00 = {
                  BHG_ID: sumItem.text,
                  id: sumItem.id,
                  value: sumItem.value,
                  BHG_Type: '符合',
                  BHG_ShiShi: '',
                  BHG_ZhengGai: '',
                  isEdit: false,
                  isAdd: true,
                }
                this.allPanding.findIndex((item) => item.id == sumItem.id) == -1
                  ? this.allPanding.push(_tempJiben_00)
                  : ''
                break
              case '不符':
                _secondbuhegePanding = 1
                let _tempJiben_0 = {
                  BHG_ID: sumItem.text,
                  id: sumItem.id,
                  value: sumItem.value,
                  BHG_Type: '不符',
                  BHG_ShiShi: '',
                  BHG_ZhengGai: '',
                  isEdit: false,
                  isAdd: true,
                }
                this.buhegeBaogao.findIndex((item) => item.id == sumItem.id) ==
                -1
                  ? this.buhegeBaogao.push(_tempJiben_0)
                  : ''
                this.allPanding.findIndex((item) => item.id == sumItem.id) == -1
                  ? this.allPanding.push(_tempJiben_0)
                  : ''
                break
              case '基本':
                _secondjibenhegePanding = 1
                let _tempJiben_1 = {
                  BHG_ID: sumItem.text,
                  id: sumItem.id,
                  value: sumItem.value,
                  BHG_Type: '基本',
                  BHG_ShiShi: '',
                  BHG_ZhengGai: '',
                  isEdit: false,
                  isAdd: true,
                }
                this.buhegeBaogao.findIndex((item) => item.id == sumItem.id) ==
                -1
                  ? this.buhegeBaogao.push(_tempJiben_1)
                  : ''
                this.allPanding.findIndex((item) => item.id == sumItem.id) == -1
                  ? this.allPanding.push(_tempJiben_1)
                  : ''
                break
              case '不适用':
                _secondbushiyongPanding = 1
                let _tempJiben_11 = {
                  BHG_ID: sumItem.text,
                  id: sumItem.id,
                  value: sumItem.value,
                  BHG_Type: '不适用',
                  BHG_ShiShi: '',
                  BHG_ZhengGai: '',
                  isEdit: false,
                  isAdd: true,
                }
                this.allPanding.findIndex((item) => item.id == sumItem.id) == -1
                  ? this.allPanding.push(_tempJiben_11)
                  : ''
                break
              default:
                _secondweiPanding = 1
                break
            }
          }

          _firsthegePanding += _secondhegePanding
          _firstbuhegePanding += _secondbuhegePanding
          _firstjibenhegePanding += _secondjibenhegePanding
          _firstbushiyongPanding += _secondbushiyongPanding
          _firstweiPanding += _secondweiPanding
          let _tep = sumItem.id.replace('.', '_')
          this[`xm${_item.value}hege`] = _firsthegePanding
          this[`xm${_item.value}buhege`] = _firstbuhegePanding
          this[`xm${_item.value}jibenhege`] = _firstjibenhegePanding
          this[`xm${_item.value}bushiyong`] = _firstbushiyongPanding
          this[`xm${_item.value}weipan`] = _firstweiPanding
          this.t_zhege = _firsthegePanding
          this.t_zjibenhege = _firstjibenhegePanding
          this.t_zbuhege = _firstbuhegePanding
          this.t_zbushiyong = _firstbushiyongPanding
        })

        // console.log('_zhege')
        // console.log(_zhege)
        // console.log(
        //   _item.name,
        //   _firsthegePanding,
        //   _firstbuhegePanding,
        //   _firstjibenhegePanding,
        //   _firstbushiyongPanding,
        //   _firstweiPanding
        // )
      },
      //状态控制
      treestate() {
        this.setAllExpand(this.defaultExpendedAll)
      },
      //设置全部展开和折叠。state参数为bool值
      setAllExpand(state) {
        var nodes = this.$refs.demoTree.store.nodesMap
        for (var i in nodes) {
          nodes[i].expanded = state
        }
      },

      //收起

      //展开

      setIdsfalse(flag) {
        for (let i = 1; i < 116; i++) this[`id${i}`] = flag
      },
      // 点击导航菜单,页面滚动到指定位置
      handleLeft(index, name) {
        console.log('index,name')
        console.log(index)
        console.log(name)
        console.log(this.selectedItem)
        let _index = this.RemoveChinese(name)

        this.selectedItem = 'tab' + _index
        console.log(this.selectedItem)
        console.log(this.$refs[`xm${index}`])

        let _obj = this.$refs[`xm${index}`]

        if (_obj) {
          let xmArray = [1, 4, 13, 21, 35, 44, 60, 72, 96, 102, 106, 112]
          let xmHeight = []
          xmHeight.push(_obj.offsetTop)
          xmHeight.push(_obj.offsetHeight)
          let showSelectedItemsHight = 50
          if (this.showSelec)
            showSelectedItemsHight =
              this.$refs[`showSelectedItems`].offsetHeight
          console.log('xmHeight')
          console.log(xmHeight)
          console.log(showSelectedItemsHight)
          let _ind = xmArray.filter((element) => element <= index)
          let _ind3 = _ind.splice(_ind.length - 1, 1)
          console.log(_ind)
          let offset = xmHeight[0]
          console.log('offset')
          console.log(offset)
          console.log(this.$refs[`xm${index}`].offsetTop)
          console.log('offset')
          if (Number(index) == 1) offset = 0
          $('html, body').animate({
            scrollTop: offset,
          })
        }
      },
      // 监听页面元素滚动,改变导航栏选中
      scrollToTop() {
        // 获取视窗高度
        var domHight = document.body.offsetHeight
        // dom滚动位置
        var scrollTop =
          window.pageYOffset ||
          document.documentElement.scrollTop ||
          document.body.scrollTop

        if (this.listBoxState) {
          //作用是点击导航栏时,延迟这里执行。
          this.listBox.map((v, i) => {
            // 获取监听元素距离视窗顶部距离
            var offsetTop = document.getElementById(`id${i}`).offsetTop
            // 获取监听元素本身高度
            var scrollHeight = document.getElementById(`id${i}`).scrollHeight

            // 如果 dom滚动位置 >= 元素距离视窗距离 && dom滚动位置 <= 元素距离视窗距离+元素本身高度
            // 则表示页面已经滚动到可视区了。
            if (
              scrollTop >= offsetTop &&
              scrollTop <= offsetTop + scrollHeight
            ) {
              // 导航栏背景色选中
              this.navgatorIndex = i
            }
          })
        }
      },
      bufuheBaogao() {
        this.$confirm(
          '此操作将永久覆盖原来的不符合项及整改措施, 是否继续?',
          '提示',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
          }
        )
          .then(() => {
            this.shengchengBuhege()
            this.$message({
              type: 'success',
              message: '删除成功!',
            })
          })
          .catch(() => {
            this.$message({
              type: 'info',
              message: '已取消删除',
            })
          })
      },
      shengchengBuhege() {
        let bgaoIDs = [
          { id: '2.1', sel: this.xm2_1Panding_4 },
          { id: '2.2', sel: this.xm2_2Panding_6 },
          { id: '3.1.1', sel: this.xm3_1_1Panding_3 },
          { id: '3.1.2', sel: this.xm3_1_2Panding_4 },
          { id: '3.2.1', sel: this.xm3_2_1Panding_6 },
          { id: '3.2.2', sel: this.xm3_2_2Panding_2 },
          { id: '3.2.3', sel: this.xm3_2_3Panding_3 },
          { id: '3.2.4', sel: this.xm3_2_4Panding_2 },
          { id: '4.1.1', sel: this.xm4_1_1Panding_8 },
          { id: '4.1.2', sel: this.xm4_1_2Panding_2 },
          { id: '4.2.1', sel: this.xm4_2_1Panding_8 },
          { id: '4.2.2', sel: this.xm4_2_2Panding_2 },
          { id: '4.3', sel: this.xm4_3Panding_10 },
          { id: '5.1.1', sel: this.xm5_1_1Panding_4 },
          { id: '5.1.2', sel: this.xm5_1_2Panding_8 },
          { id: '5.2.1', sel: this.xm5_2_1Panding_20 },
          { id: '5.2.2', sel: this.xm5_2_2Panding_3 },
          { id: '5.3.1', sel: this.xm5_3_1Panding_7 },
          { id: '5.3.2', sel: this.xm5_3_2Panding_7 },
          { id: '5.4.1', sel: this.xm5_4_1Panding_14 },
          { id: '5.4.2', sel: this.xm5_4_2Panding_11 },
          { id: '5.5', sel: this.xm5_5Panding_3 },
          { id: '6.1.2', sel: this.xm6_1_2Panding_10 },
          { id: '6.1.3', sel: this.xm6_1_3Panding_6 },
          { id: '6.1.4', sel: this.xm6_1_4Panding_2 },
          { id: '6.2.1', sel: this.xm6_2_1Panding_8 },
          { id: '6.2.2', sel: this.xm6_2_2Panding_5 },
          { id: '7.1.2', sel: this.xm7_1_2Panding_14 },
          { id: '7.1.3', sel: this.xm7_1_3Panding_2 },
          { id: '7.1.4', sel: this.xm7_1_4Panding_11 },
          { id: '7.1.5', sel: this.xm7_1_5Panding_9 },
          { id: '7.1.6', sel: this.xm7_1_6Panding_6 },
          { id: '7.2.2', sel: this.xm7_2_2Panding_12 },
          { id: '7.2.3', sel: this.xm7_2_3Panding_2 },
          { id: '7.2.4', sel: this.xm7_2_4Panding_11 },
          { id: '7.2.5', sel: this.xm7_2_5Panding_3 },
          { id: '7.2.6', sel: this.xm7_2_6Panding_9 },
          { id: '7.2.7', sel: this.xm7_2_7Panding_4 },
          { id: '8.1.1', sel: this.xm8_1_1Panding_10 },
          { id: '8.1.2', sel: this.xm8_1_2Panding_8 },
          { id: '8.1.3', sel: this.xm8_1_3Panding_4 },
          { id: '8.2.1', sel: this.xm8_2_1Panding_9 },
          { id: '8.2.3', sel: this.xm8_2_3Panding_14 },
          { id: '8.2.4', sel: this.xm8_2_4Panding_7 },
          { id: '8.2.5', sel: this.xm8_2_5Panding_4 },
          { id: '8.2.6', sel: this.xm8_2_6Panding_2 },
          { id: '9.1', sel: this.xm9_1Panding_3 },
          { id: '9.2.1', sel: this.xm9_2_1Panding_2 },
          { id: '9.2.2', sel: this.xm9_2_2Panding_2 },
          { id: '9.3.1', sel: this.xm9_3_1Panding_3 },
          { id: '9.3.2', sel: this.xm9_3_2Panding_2 },
          { id: '9.4.1', sel: this.xm9_4_1Panding_4 },
          { id: '9.4.2', sel: this.xm9_4_2Panding_4 },
          { id: '9.4.3', sel: this.xm9_4_3Panding_4 },
          { id: '9.4.4', sel: this.xm9_4_4Panding_4 },
          { id: '9.5', sel: this.xm9_5Panding_11 },
          { id: '9.6.1', sel: this.xm9_6_1Panding_2 },
          { id: '9.6.2', sel: this.xm9_6_2Panding_3 },
          { id: '9.6.3', sel: this.xm9_6_3Panding_3 },
          { id: '9.6.4', sel: this.xm9_6_4Panding_4 },
          { id: '9.6.5', sel: this.xm9_6_5Panding_2 },
          { id: '9.7.1', sel: this.xm9_7_1Panding_10 },
          { id: '9.7.2', sel: this.xm9_7_2Panding_2 },
          { id: '9.8', sel: this.xm9_8Panding_6 },
          { id: '10.1', sel: this.xm10_1Panding_5 },
          { id: '10.2', sel: this.xm10_2Panding_7 },
          { id: '10.3', sel: this.xm10_3Panding_2 },
          { id: '10.4', sel: this.xm10_4Panding_2 },
          { id: '10.5', sel: this.xm10_5Panding_10 },
          { id: '11.1', sel: this.xm11_1Panding_4 },
          { id: '11.2', sel: this.xm11_2Panding_3 },
          { id: '11.3', sel: this.xm11_3Panding_3 },
          { id: '12.1', sel: this.xm12_1Panding_4 },
          { id: '12.2.1', sel: this.xm12_2_1Panding_2 },
          { id: '12.2.2', sel: this.xm12_2_2Panding_4 },
          { id: '12.3', sel: this.xm12_3Panding_3 },
          { id: '13.1', sel: this.xm13_1Panding_2 },
          { id: '13.2', sel: this.xm13_2Panding_3 },
          { id: '13.3', sel: this.xm13_3Panding_2 },
        ]
        this.buhegeBaogao.forEach((item) => {
          bgaoIDs.forEach((itemIds) => {
            console.log(itemIds.id)
            console.log(item.value)
            if (itemIds.id == item.value) item.BHG_ShiShi = itemIds.sel
          })
        })
        const _that = this
        const saveObj = {}
        this.PS_ID = this.$store.state.detail.PS_ID
        if (this.PS_ID != '') {
          let that = this
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateBuHeGe', //请求地址
            data: JSON.stringify({
              PS_ID: _that.PS_ID,
              PS_BuHeGe: this.buhegeBaogao,
            }), //表单序列化
            success: function (result) {},
            error: function (result) {
              console.log(result.responseText)
              _that.$baseMessage(result.responseText, 'success')
              _that.showEdit = false
            },
          })
        } else {
          _that.$alert('请选择或新建评审任务', '提示', {
            confirmButtonText: '确定',
            callback: (action) => {
              //_that.$baseMessage('请选择或新建评审任务', 'error')
            },
          })
        }
      },
      handleScroll() {
        var scrollTop =
          window.pageYOffset ||
          document.documentElement.scrollTop ||
          document.body.scrollTop
        if (document.querySelector('#searchBar')) {
          var offsetTop = document.querySelector('#searchBar').offsetTop
          if (scrollTop > offsetTop + 50) {
            this.searchBarFixed = true
          } else {
            this.searchBarFixed = false
          }
        }
        if (document.querySelector('#tipsBar')) {
          var offsetTop = document.querySelector('#tipsBar').offsetTop
          if (scrollTop > offsetTop + 50) {
            this.tipsFixed = true
          } else {
            this.tipsFixed = false
          }
        }
      },
      //全选
      handleCheckAllChange(val) {
        console.log(`全选`)
        console.log(this.checkAll)
        this.checkNodeKeys = val ? treeOptions : []
        this.isIndeterminate = false
        this.setCheckedKeysArray(this.checkNodeKeys)
        this.setIdsfalse(this.checkAll)
        this.getCheckedNodes()
        this.ps_XiangMu = this.checkNodeKeys
        console.log('this.checkNodeKeys')
        console.log(this.checkNodeKeys)
        console.log(this.ps_XiangMu)
      },
      // 反选
      inverse() {
        let res = this.$refs.demoTree
        let nodes = res.getCheckedNodes(true, true)
        this.batchSelect(this.data2, res, true, nodes)
        this.getCheckedNodes()
      },
      // 设置节点选中
      setCheckedKeysArray(idsArray) {
        this.$refs.demoTree.setCheckedKeys(idsArray)
        this.$nextTick(() => {
          this.checkNodes = this.$refs.demoTree.getCheckedNodes(true, true)
          console.log('this.checkNodes')
          console.log(this.checkNodes)
        })
        if (idsArray.length > 1)
          idsArray.forEach((item) => {
            this.$nextTick(() => {
              this.setIds(item)
            })
          })
        else this.setIdsfalse()
        console.log(`设置节点选中`)
      },
      changeShow: function (e, flag = false) {
        let temp
        let tempVar = ''
        let disp = (this.dsiplayMode = this.dsiplayMode == 'none' ? '' : 'none')
        this.$refs[e] ? (this.$refs[e].style.display = disp) : ''

        //this.isShow = !this.isShow
      },

      changeAllShow() {
        if (this.defaultExpanDetail) {
          this.$refs['xm1'] == null
            ? ''
            : (this.$refs['xm1'].style.display = '')
          this.$refs['xm4'] == null
            ? ''
            : (this.$refs['xm4'].style.display = '')
          this.$refs['xm13'] == null
            ? ''
            : (this.$refs['xm13'].style.display = '')
          this.$refs['xm21'] == null
            ? ''
            : (this.$refs['xm21'].style.display = '')
          this.$refs['xm35'] == null
            ? ''
            : (this.$refs['xm35'].style.display = '')
          this.$refs['xm44'] == null
            ? ''
            : (this.$refs['xm44'].style.display = '')
          this.$refs['xm60'] == null
            ? ''
            : (this.$refs['xm60'].style.display = '')
          this.$refs['xm72'] == null
            ? ''
            : (this.$refs['xm72'].style.display = '')
          this.$refs['xm96'] == null
            ? ''
            : (this.$refs['xm96'].style.display = '')
          this.$refs['xm102'] == null
            ? ''
            : (this.$refs['xm102'].style.display = '')
          this.$refs['xm106'] == null
            ? ''
            : (this.$refs['xm106'].style.display = '')
          this.$refs['xm112'] == null
            ? ''
            : (this.$refs['xm112'].style.display = '')
        } else {
          this.$refs['xm1'] == null
            ? ''
            : (this.$refs['xm1'].style.display = 'none')
          this.$refs['xm4'] == null
            ? ''
            : (this.$refs['xm4'].style.display = 'none')
          this.$refs['xm13'] == null
            ? ''
            : (this.$refs['xm13'].style.display = 'none')
          this.$refs['xm21'] == null
            ? ''
            : (this.$refs['xm21'].style.display = 'none')
          this.$refs['xm35'] == null
            ? ''
            : (this.$refs['xm35'].style.display = 'none')
          this.$refs['xm44'] == null
            ? ''
            : (this.$refs['xm44'].style.display = 'none')
          this.$refs['xm60'] == null
            ? ''
            : (this.$refs['xm60'].style.display = 'none')
          this.$refs['xm72'] == null
            ? ''
            : (this.$refs['xm72'].style.display = 'none')
          this.$refs['xm96'] == null
            ? ''
            : (this.$refs['xm96'].style.display = 'none')
          this.$refs['xm102'] == null
            ? ''
            : (this.$refs['xm102'].style.display = 'none')
          this.$refs['xm106'] == null
            ? ''
            : (this.$refs['xm106'].style.display = 'none')
          this.$refs['xm112'] == null
            ? ''
            : (this.$refs['xm112'].style.display = 'none')
        }
        this.defaultExpanDetail = !this.defaultExpanDetail
      },

      getCheckedKeys() {
        // console.log(this.$refs.demoTree.getCheckedKeys())
      },

      // 获取tree数据
      async getTreeListFuc(flag) {
        const { data } = await getTreeList()

        console.log('tree------data')
        console.log(data)
        this.tempTreeData = data
        this.data2 = data
      },
      // 节点过滤操作
      filterNode(value, data) {
        if (!value) return true
        return data.name.indexOf(value) !== -1
      },
      // 设置节点选中
      setCheckedKeys() {
        let idsArray = [1, 4, 13, 21, 35, 44, 60, 72, 96, 102, 106, 112]
        let PS_XiangMu = this.ps_XiangMu
        if (PS_XiangMu != '') idsArray = PS_XiangMu.split(',')
        this.$refs.demoTree.setCheckedKeys(idsArray)
        idsArray.forEach((item) => {
          this.$nextTick(() => {
            this.setIds(item)
          })
        })
        console.log(`初始化时设置节点选中`)
      },
      // 点击叶子节点
      nodeClick(data, node, el) {
        //this.checkNode(data, node, el)
        console.log(`点击叶子节点`)
        console.log(data)
        console.log(data.id)
        this.handleLeft(data.id, data.name)
      },
      checkChange() {},
      // 节点选中操作
      checkNode(data, node, el) {
        this.checkNodeKeys = node.checkedKeys
        console.log(`节点选中操作,选中内容为`)
        this.getCheckedNodes()
        this.getCheckedKeys()
      },
      showSelected() {
        console.log(`showSelected`)
        this.getCheckedNodes()
        this.showSelec = !this.showSelec
      },

      // 节点展开操作
      nodeExpand(data, node, el) {
        console.log(`节点展开操作`)
        this.defaultExpendedKeys.push(data.id)
      },
      // 节点关闭操作
      nodeCollapse(data, node, el) {
        console.log(`节点关闭操作`)
        this.defaultExpendedKeys.splice(
          this.defaultExpendedKeys.findIndex((item) => item.id === data.id),
          1
        )
      },

      selectTreeNodeClick(data, node, el) {
        console.log(`点击叶子节点`)
        if (data.rank >= this.selectLevel) {
          this.singleSelectTreeVal = data.name
          this.singleSelectTreeKey = data.id
          this.$refs.singleTree.blur()
        }
      },
      // 全选处理方法
      batchSelect(nodes, refs, flag, seleteds) {
        if (typeof nodes != 'undefined') {
          console.log('selected nodes')
          console.log(nodes)
          nodes.forEach((element) => {
            refs.setChecked(element, flag, true)
            // this[`id${element.id}`] = flag
          })
        }

        if (typeof seleteds != 'undefined') {
          console.log('selected nodes')
          console.log(seleteds)

          seleteds.forEach((node) => {
            refs.setChecked(node, !flag, true)
            // this[`id${node.id}`] = flag
          })
        }
      },
      //获取或更新全部选中的项目
      getCheckedNodes() {
        this.defaultCheckedKeys = this.$store.state.detail.PS_XiangMu.split(',')
        console.log('this.defaultCheckedKeys')
        console.log(this.$store.state.detail)
        console.log(this.defaultCheckedKeys)
        this.selectedIds = []
        this.selectCount = 0
        this.foujue = 0
        this.kaohe = 0
        console.log('this.$refs')
        console.log(this)
        this.checkNodes = this.$refs.demoTree.getCheckedNodes(false, true)
        this.checkNodes.forEach((item) => {
          // console.log(item.title)
          // console.log('item.title')
          item.children.length == 0 ? this.selectCount++ : ''
          item.name.indexOf('★') != -1 ? this.foujue++ : ''
        })
        this.kaohe = this.selectCount - this.foujue

        console.log('三级列表编号及序号')
        console.log(this.checkNodes)
        let _ids = []
        for (let i = 1; i <= 115; i++) {
          _ids.push(i + '')
          this['id' + i] = false
        }
        let _select = []
        let _no_select = []
        this.checkNodes.forEach((element) => {
          this.setIds(element.id)
          _select.push(element.id)
          if (element.children.length == 0) {
            this.selectedIds.push(element.value)
            //console.log(element.name)
          }
          // console.log(
          //   element.value + '\t' + element.id + '\t' + this['id' + element.id]
          // )
        })
        _no_select = _ids
          .concat(_select)
          .filter((v) => !_ids.includes(v) || !_select.includes(v)) // [1,3,4,5]
        // console.log('_no_select')
        // console.log(_ids)
        // console.log(_select)
        // console.log(_no_select)
        for (let t = 0; t < _no_select.length; t++) {
          this['id' + _no_select[t]] = false
        }
        //.concat(this.$refs.demoTree.getHalfCheckedKeys())

        const chekItem = this.$refs.demoTree.getCheckedNodes(false, true)
        let checkItems_ID = []
        let checkItems_Name = []
        chekItem.map((item) => {
          console.log(item.name + '****' + item.title + '****' + item.id)
          checkItems_ID.push(item.id)
          checkItems_Name.push(item.name)
        })
        //this.ps_XiangMu = checkItems_ID.join(',')
        this.ps_XiangMu_Name = checkItems_Name.join(',')
        let _num = this.RemoveChinese(this.ps_XiangMu_Name)
        this.selectedItem = 'tab' + _num
        console.log('selectedItem')
        console.log(this.checkItems_Name)
        console.log(this.ps_XiangMu_Name)
        console.log(_num)
        // console.log(this.$refs.demoTree.getCheckedNodes())
        // console.log(this.$refs.demoTree.getCheckedKeys())
        // console.log(this.ps_XiangMu)
      },
      RemoveChinese(strValue) {
        if (strValue != null && strValue != '') {
          let _strValue = strValue.replace('★', '').slice(0, 2).replace('.', '')
          var reg = /[\u4e00-\u9fa5]/g
          return _strValue.replace(reg, '')
        } else return '2'
      },
      setIds(_id) {
        let id = _id + ''
        switch (id) {
          case '1':
            this.id1 = true
            break
          case '2':
            this.id2 = true
            break
          case '3':
            this.id3 = true
            break
          case '4':
            this.id4 =
              this.id5 =
              this.id6 =
              this.id7 =
              this.id8 =
              this.id9 =
              this.id10 =
              this.id11 =
              this.id12 =
                true
            break
          case '5':
            this.id4 = this.id5 = this.id6 = this.id7 = true
            break
          case '6':
            this.id4 = this.id5 = this.id6 = true
            break
          case '7':
            this.id4 = this.id5 = this.id7 = true
            break
          case '8':
            this.id4 =
              this.id8 =
              this.id9 =
              this.id10 =
              this.id11 =
              this.id12 =
                true
            break
          case '9':
            this.id4 = this.id8 = this.id9 = true
            break
          case '10':
            this.id4 = this.id8 = this.id10 = true
            break
          case '11':
            this.id4 = this.id8 = this.id11 = true
            break
          case '12':
            this.id4 = this.id8 = this.id12 = true
            break
          case '13':
            this.id13 =
              this.id14 =
              this.id15 =
              this.id16 =
              this.id17 =
              this.id18 =
              this.id19 =
              this.id20 =
                true
            break
          case '14':
            this.id13 = this.id14 = this.id15 = this.id16 = this.id20 = true
            break
          case '15':
            this.id13 = this.id14 = this.id15 = true
            break
          case '16':
            this.id13 = this.id14 = this.id16 = true
            break
          case '17':
            this.id13 = this.id17 = this.id18 = this.id19 = true
            break
          case '18':
            this.id13 = this.id17 = this.id18 = true
            break
          case '19':
            this.id13 = this.id17 = this.id19 = true
            break
          case '20':
            this.id13 = this.id20 = true
            break
          case '21':
            this.id21 =
              this.id22 =
              this.id23 =
              this.id24 =
              this.id25 =
              this.id26 =
              this.id27 =
              this.id28 =
              this.id29 =
              this.id30 =
              this.id31 =
              this.id32 =
              this.id33 =
              this.id34 =
                true
            break
          case '22':
            this.id21 = this.id22 = this.id23 = this.id24 = true
            break
          case '23':
            this.id21 = this.id22 = this.id23 = true
            break
          case '24':
            this.id21 = this.id22 = this.id24 = true
            break
          case '25':
            this.id21 = this.id25 = this.id26 = this.id27 = true
            break
          case '26':
            this.id21 = this.id25 = this.id26 = true
            break
          case '27':
            this.id21 = this.id25 = this.id27 = true
            break
          case '28':
            this.id21 = this.id28 = this.id29 = this.id30 = true
            break
          case '29':
            this.id21 = this.id28 = this.id29 = true
            break
          case '30':
            this.id21 = this.id28 = this.id30 = true
            break
          case '31':
            this.id21 = this.id31 = this.id32 = this.id33 = true
            break
          case '32':
            this.id21 = this.id31 = this.id32 = true
            break
          case '33':
            this.id21 = this.id31 = this.id33 = true
            break
          case '34':
            this.id21 = this.id34 = true
            break
          case '35':
            this.id35 =
              this.id36 =
              this.id37 =
              this.id38 =
              this.id39 =
              this.id40 =
              this.id41 =
              this.id42 =
              this.id43 =
                true
            break
          case '36':
            this.id35 =
              this.id36 =
              this.id37 =
              this.id38 =
              this.id39 =
              this.id40 =
                true
            break
          case '37':
            this.id35 = this.id36 = this.id37 = true
            break
          case '38':
            this.id35 = this.id36 = this.id38 = true
            break
          case '39':
            this.id35 = this.id36 = this.id39 = true
            break
          case '40':
            this.id35 = this.id36 = this.id40 = true
            break
          case '41':
            this.id35 = this.id41 = this.id42 = this.id43 = true
            break
          case '42':
            this.id35 = this.id41 = this.id42 = true
            break
          case '43':
            this.id35 = this.id41 = this.id43 = true
            break
          case '44':
            this.id44 =
              this.id45 =
              this.id46 =
              this.id47 =
              this.id48 =
              this.id49 =
              this.id50 =
              this.id51 =
              this.id52 =
              this.id53 =
              this.id54 =
              this.id55 =
              this.id56 =
              this.id57 =
              this.id58 =
              this.id59 =
                true
            break
          case '45':
            this.id44 =
              this.id45 =
              this.id46 =
              this.id47 =
              this.id48 =
              this.id49 =
              this.id50 =
              this.id51 =
                true
            break
          case '46':
            this.id44 = this.id45 = this.id46 = true
            break
          case '47':
            this.id44 = this.id45 = this.id47 = true
            break
          case '48':
            this.id44 = this.id45 = this.id48 = true
            break
          case '49':
            this.id44 = this.id45 = this.id49 = true
            break
          case '50':
            this.id44 = this.id45 = this.id50 = true
            break
          case '51':
            this.id44 = this.id45 = this.id51 = true
            break
          case '52':
            this.id44 =
              this.id52 =
              this.id53 =
              this.id54 =
              this.id55 =
              this.id56 =
              this.id57 =
              this.id58 =
              this.id59 =
                true
            break
          case '53':
            this.id44 = this.id52 = this.id53 = true
            break
          case '54':
            this.id44 = this.id52 = this.id54 = true
            break
          case '55':
            this.id44 = this.id52 = this.id55 = true
            break
          case '56':
            this.id44 = this.id52 = this.id56 = true
            break
          case '57':
            this.id44 = this.id52 = this.id57 = true
            break
          case '58':
            this.id44 = this.id52 = this.id58 = true
            break
          case '59':
            this.id44 = this.id52 = this.id59 = true
            break
          case '60':
            this.id60 =
              this.id61 =
              this.id62 =
              this.id63 =
              this.id64 =
              this.id65 =
              this.id66 =
              this.id67 =
              this.id68 =
              this.id69 =
              this.id70 =
              this.id71 =
                true
            break
          case '61':
            this.id60 = this.id61 = this.id62 = this.id63 = this.id64 = true
            break
          case '62':
            this.id60 = this.id61 = this.id62 = true
            break
          case '63':
            this.id60 = this.id61 = this.id63 = true
            break
          case '64':
            this.id60 = this.id61 = this.id64 = true
            break
          case '65':
            this.id60 =
              this.id65 =
              this.id66 =
              this.id67 =
              this.id68 =
              this.id69 =
              this.id70 =
              this.id71 =
                true
            break
          case '66':
            this.id60 = this.id65 = this.id66 = true
            break
          case '67':
            this.id60 = this.id65 = this.id67 = true
            break
          case '68':
            this.id60 = this.id65 = this.id68 = true
            break
          case '69':
            this.id60 = this.id65 = this.id69 = true
            break
          case '70':
            this.id60 = this.id65 = this.id70 = true
            break
          case '71':
            this.id60 = this.id65 = this.id71 = true
            break
          case '72':
            this.id72 =
              this.id73 =
              this.id74 =
              this.id75 =
              this.id76 =
              this.id77 =
              this.id78 =
              this.id79 =
              this.id80 =
              this.id81 =
              this.id82 =
              this.id83 =
              this.id84 =
              this.id85 =
              this.id86 =
              this.id87 =
              this.id88 =
              this.id89 =
              this.id90 =
              this.id91 =
              this.id92 =
              this.id93 =
              this.id94 =
              this.id95 =
                true
            break
          case '73':
            this.id72 = this.id73 = true
            break
          case '74':
            this.id72 = this.id74 = this.id75 = this.id76 = true
            break
          case '75':
            this.id72 = this.id74 = this.id75 = true
            break
          case '76':
            this.id72 = this.id74 = this.id76 = true
            break
          case '77':
            this.id72 = this.id77 = this.id78 = this.id79 = true
            break
          case '78':
            this.id72 = this.id77 = this.id78 = true
            break
          case '79':
            this.id72 = this.id77 = this.id79 = true
            break
          case '80':
            this.id72 =
              this.id80 =
              this.id81 =
              this.id82 =
              this.id83 =
              this.id84 =
                true
            break
          case '81':
            this.id72 = this.id80 = this.id81 = true
            break
          case '82':
            this.id72 = this.id80 = this.id82 = true
            break
          case '83':
            this.id72 = this.id80 = this.id83 = true
            break
          case '84':
            this.id72 = this.id80 = this.id84 = true
            break
          case '85':
            this.id72 = this.id85 = true
            break
          case '86':
            this.id72 =
              this.id86 =
              this.id87 =
              this.id88 =
              this.id89 =
              this.id90 =
              this.id91 =
                true
            break
          case '87':
            this.id72 = this.id86 = this.id87 = true
            break
          case '88':
            this.id72 = this.id86 = this.id88 = true
            break
          case '89':
            this.id72 = this.id86 = this.id89 = true
            break
          case '90':
            this.id72 = this.id86 = this.id90 = true
            break
          case '91':
            this.id72 = this.id86 = this.id91 = true
            break
          case '92':
            this.id72 = this.id92 = this.id93 = this.id94 = true
            break
          case '93':
            this.id72 = this.id92 = this.id93 = true
            break
          case '94':
            this.id72 = this.id92 = this.id94 = true
            break
          case '95':
            this.id72 = this.id95 = true
            break
          case '96':
            this.id96 =
              this.id97 =
              this.id98 =
              this.id99 =
              this.id100 =
              this.id101 =
                true
            break
          case '97':
            this.id96 = this.id97 = true
            break
          case '98':
            this.id96 = this.id98 = true
            break
          case '99':
            this.id96 = this.id99 = true
            break
          case '100':
            this.id96 = this.id100 = true
            break
          case '101':
            this.id96 = this.id101 = true
            break
          case '102':
            this.id102 = this.id103 = this.id104 = this.id105 = true
            break
          case '103':
            this.id102 = this.id103 = true
            break
          case '104':
            this.id102 = this.id104 = true
            break
          case '105':
            this.id102 = this.id105 = true
            break
          case '106':
            this.id106 =
              this.id107 =
              this.id108 =
              this.id109 =
              this.id110 =
              this.id111 =
                true
            break
          case '107':
            this.id106 = this.id107 = true
            break
          case '108':
            this.id106 = this.id108 = this.id109 = this.id110 = true
            break
          case '109':
            this.id106 = this.id108 = this.id109 = true
            break
          case '110':
            this.id106 = this.id108 = this.id110 = true
            break
          case '111':
            this.id106 = this.id111 = true
            break
          case '112':
            this.id112 = this.id113 = this.id114 = this.id115 = true
            break
          case '113':
            this.id112 = this.id113 = true
            break
          case '114':
            this.id112 = this.id114 = true
            break
          case '115':
            this.id112 = this.id115 = true
            break
          default:
            console.log(`Sorry, we are out of ${id}.`)
        }
      },
      // 节点选中操作

      /* 单选/多选树方法-------------------结束 */
    },
  }
</script>

<style scoped>
  .use-flexbox {
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .use-flexbox span {
    padding-left: 5px;
  }

  .xiangmu {
    padding: 0px 10px 0px 10px;
  }

  .leftSum {
    float: left;
    display: inline-block;
  }

  .leftSum span {
    float: right;
    display: inline-block;
  }

  .neirong {
    background-color: #f8f8f8;
    padding: 10px;
  }

  .neirong span {
    padding-left: 5px;
  }

  .xiangmu p {
    text-align: left;
    align-items: center;
    justify-content: center;
    border-bottom: 1px dashed #d0d0d0;
    padding: 5px;
    display: block;
  }

  .xiangmu p:hover {
    font-weight: bold;
    color: red;
    background: #c3f4bc;
  }

  .xiangmu p span {
    display: inline-block;
    margin: 0px;
    background: cornsilk;
  }

  .xiangmu p:hover span {
    font-weight: bold;
    color: red;
  }

  .xiangmu p span .el-checkbox__input {
    padding-top: 2px;
  }

  .icon-panel {
    text-align: center;
    cursor: pointer;
  }

  .icon-panel:hover {
    border-color: #ffc069;
  }

  .icon-panel span {
    text-align: left;
    cursor: pointer;
  }

  .icon-panel-height {
    text-align: left;
    cursor: pointer;
  }

  .el-card__body {
    padding: 0px;
  }

  .el-card__header {
    background: #f6f8f9;
  }

  .Sumary {
    height: 24px;
  }

  .el-card__body span {
    display: inherit;
  }

  .el-card__body svg {
    font-size: 50px;
  }

  .el-card__body p {
    min-height: 24px;
    line-height: 24px;
    margin: 5px;
  }

  .bottom-btn {
    margin: 5px 10px 15px 0;
  }

  .svg-inline--fa {
    font-size: 30px;
  }

  .el-radio {
    margin-right: 0px;
  }

  .el-tag--success {
    font-size: 16px;
    font-weight: bold;
    margin: 5px;
  }

  .el-tag {
    height: 40px;
    line-height: 40px;
    font-size: 14px;
    font-weight: bolder;
  }

  .leftSum {
    text-align: center;
    display: inline-block;
    float: left;
    font-size: 18px;
    font-weight: bold;
  }

  .leftSum .countStyle {
    /* margin-left: 20px; */
    float: right;
    margin-right: 20px;
    position: relative;
    left: 395px;
    font-size: 14px;
    /* border: 1px solid; */
  }

  .jiedai {
    width: 100px;
    display: inline-block;
  }
  .rigthSum {
    text-align: center;
    display: inline-block;
    float: right;
    margin-top: -10px;
  }

  .rigthSum div {
    margin: 0px;
    display: inline-block;
  }

  .rigthSum span {
    margin-top: 10px;
    min-width: 10px;
    height: 24px;
    line-height: 24px;
  }

  p .el-checkbox {
    margin: 2px 0px 0px 10px;
  }

  .element {
    height: 24px;
    line-height: 24px;
    font-weight: bold;
    width: 80px;
  }

  .secondDanxiang {
    float: right;
    padding-right: 10px;
  }

  .secondDanxiang div {
    display: inline;
  }

  .secondDanxiang div span {
    min-width: 20px;
    height: 24px;
    line-height: 24px;
  }

  .danxiang {
    float: right;
    padding-right: 10px;
  }

  .danxiang span {
    margin: 0px;
    padding: 0px;
  }

  .el-checkbox {
    margin-right: 0px;
  }

  .isFixed {
    position: fixed;
    background-color: #fff;
    top: 140px;
    height: 500px;
    width: 348px;
    right: 20px;
  }
  .tipsFixed {
    position: fixed;
    background-color: #c2f4bc0d;
    top: 120px;
    z-index: 9;
    width: 100%;
  }
  .vab-filter-tree {
    height: 600px;
    overflow: scroll;
  }

  .cssShowSelected {
    text-align: left;
    float: right;
    height: 24px;
    line-height: 24px;
    display: inline-block;
    position: relative;
  }

  .cssShow {
    display: inline-block;
    background-color: #f6f8f9;
    width: 100%;
    padding: 5px;
  }

  .cssShow span {
    height: 24px;
    line-height: 24px;
    display: inline-block;
    margin: 1px;
    padding: 0px;
    cursor: pointer;
  }

  .cssShowSelectedOne {
    height: 24px;
    line-height: 24px;
    display: inline-block;
    margin: 0px;
    padding: 0px;
    min-width: 25px;
    text-align: center;
  }

  .el-backtop {
    background-color: #ffc069;
  }

  .el-backtop:hover {
    background-color: #9d9c9c;
  }
  .fouju {
    color: red;
    font-weight: bold;
    background-color: #ff85c0;
    border: 1px dashed #ff85c0;
    border-radius: 5px;
    padding: 0px 20px 0px 20px;
  }

  .bigFont {
    font-weight: bold;
    display: inline-block;
  }

  .el-alert__description {
    width: 100%;
  }
  .el-radio__label {
    padding: 0px;
  }

  .red {
    color: red;
  }

  .red .el-checkbox-button__inner {
    background: red;
  }

  .black {
    color: red;
  }

  .weipanding {
    border: 2px solid crimson;
    background: crimson;
    padding-top: 20px;
    padding-bottom: 20px;
  }

  .tipCount {
    padding: 10px;
  }

  .tipPanding {
    padding: 10px;
  }

  /* 选中后的字体颜色 */

  .el-radio__input.is-checked + .el-radio__label {
    color: #d42828 !important;
    font-size: 16px !important;
  }

  /* 选中后小圆点的颜色 */

  .el-radio__input.is-checked .el-radio__inner,
  .el-checkbox__input.is-checked .el-checkbox__inner {
    background: #d42828 !important;
    border-color: #d42828 !important;
  }

  .el-radio__inner,
  .el-checkbox__inner {
    border: 1px solid #cf3df0 !important;
  }

  .el-textarea textarea,
  .el-input input {
    color: #2e06fb;
    font-weight: bold;
  }

  .el-date-editor--date span {
    background-color: transparent !important;
  }

  .jianjieSpan {
    width: 100% !important;
    float: left !important;
    overflow: hidden !important;
    text-overflow: ellipsis !important;
    white-space: normal !important;
  }

  .el-tag--success {
    margin-top: 0px;
  }
  .bhgStyle {
    height: 30px !important;
    line-height: 30px !important;
    margin-left: 2px;
  }
  .el-tabs--border-card > .el-tabs__header .el-tabs__item {
    transition: all 0.3s cubic-bezier(0.645, 0.045, 0.355, 1);
    border: 1px solid #db64645c;
    margin-top: -1px;
    color: #909399;
    padding: 0 5px;
  }
  .el-tabs__item {
    padding: 0 2px !important;
  }
  .el-alert__content {
    width: 100% !important;
  }
  .el-alert__description {
    width: 90% !important;
  }
  .jielun {
    color: blue;
    font-weight: bold;
  }
  .jielunBhg {
    color: red;
    font-weight: bold;
  }
</style>
