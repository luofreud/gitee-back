import {useBaseApi} from '/@/api/base';

// 充值记录接口服务
export const useXzRechargelogApi = () => {
	const baseApi = useBaseApi("xzRechargelog");
	return {
		// 分页查询充值记录
		page: baseApi.page,
		// 查看充值记录详细
		detail: baseApi.detail,
		// 新增充值记录
		add: baseApi.add,
		// 更新充值记录
		update: baseApi.update,
		// 删除充值记录
		delete: baseApi.delete,
		// 批量删除充值记录
		batchDelete: baseApi.batchDelete,
		// 导出充值记录数据
		exportData: baseApi.exportData,
		// 导入充值记录数据
		importData: baseApi.importData,
		// 下载充值记录数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 充值记录实体
export interface XzRechargelog {
	// 主键Id
	id: number;
	// 用户id
	uid: number;
	// 充值金额
	money: number;
	// 充值类型：1：微信，2：支付宝，3：系统赠送
	rechargetype: number;
	// 备注
	mark: string;
	// 充值时间
	createtime: string;
}