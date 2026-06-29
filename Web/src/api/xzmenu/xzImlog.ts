import {useBaseApi} from '/@/api/base';

// 咨询连麦记录接口服务
export const useXzImlogApi = () => {
	const baseApi = useBaseApi("xzImlog");
	return {
		// 分页查询咨询连麦记录
		page: baseApi.page,
		// 查看咨询连麦记录详细
		detail: baseApi.detail,
		// 新增咨询连麦记录
		add: baseApi.add,
		// 更新咨询连麦记录
		update: baseApi.update,
		// 删除咨询连麦记录
		delete: baseApi.delete,
		// 批量删除咨询连麦记录
		batchDelete: baseApi.batchDelete,
		// 导出咨询连麦记录数据
		exportData: baseApi.exportData,
		// 导入咨询连麦记录数据
		importData: baseApi.importData,
		// 下载咨询连麦记录数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 咨询连麦记录实体
export interface XzImlog {
	// 主键Id
	id: number;
	// 
	uid: number;
	// 
	tid: number;
	// 0：普通连麦，1：1v1连麦，2：及时通话
	itype: number;
	// 消费星钻
	xzmoney: number;
	// 订单号
	orderno: string;
	// 0：不删除，1：删除
	isdel: number;
	// 单价
	price: number;
	// 0：未连麦，1：正在连麦，2：已完成连麦
	state: number;
	// 连麦时长
	imtime: number;
	// 结束时间
	overtime: string;
	// 0：正常，1：投诉状态
	ostate: number;
	// createtime
	createtime: string;
}