import {useBaseApi} from '/@/api/base';

// 系统优惠券接口服务
export const useXzCouponApi = () => {
	const baseApi = useBaseApi("xzCoupon");
	return {
		// 分页查询系统优惠券
		page: baseApi.page,
		// 查看系统优惠券详细
		detail: baseApi.detail,
		// 新增系统优惠券
		add: baseApi.add,
		// 更新系统优惠券
		update: baseApi.update,
		// 删除系统优惠券
		delete: baseApi.delete,
		// 批量删除系统优惠券
		batchDelete: baseApi.batchDelete,
		// 导出系统优惠券数据
		exportData: baseApi.exportData,
		// 导入系统优惠券数据
		importData: baseApi.importData,
		// 下载系统优惠券数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 系统优惠券实体
export interface XzCoupon {
	// 主键Id
	id: number;
	// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
	ctype: number;
	// 
	stime: string;
	// 
	etime: string;
	// 
	name: string;
	// 0：正常，1：删除
	isdel: number;
	// -1：无限制
	count: number;
	// 
	lqcount: number;
	// 
	createtime: string;
}