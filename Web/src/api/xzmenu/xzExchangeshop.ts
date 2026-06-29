import {useBaseApi} from '/@/api/base';

// 星币兑换商城接口服务
export const useXzExchangeshopApi = () => {
	const baseApi = useBaseApi("xzExchangeshop");
	return {
		// 分页查询星币兑换商城
		page: baseApi.page,
		// 查看星币兑换商城详细
		detail: baseApi.detail,
		// 新增星币兑换商城
		add: baseApi.add,
		// 更新星币兑换商城
		update: baseApi.update,
		// 删除星币兑换商城
		delete: baseApi.delete,
		// 批量删除星币兑换商城
		batchDelete: baseApi.batchDelete,
		// 导出星币兑换商城数据
		exportData: baseApi.exportData,
		// 导入星币兑换商城数据
		importData: baseApi.importData,
		// 下载星币兑换商城数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 星币兑换商城实体
export interface XzExchangeshop {
	// 主键Id
	id: number;
	// 商品名称
	goodname: string;
	// 商品图片
	goodimg: string;
	// 兑换星币数量
	xbmoney: number;
	// 商品数量
	count: number;
	// 
	xzmoney: number;
	// 类型id
	goodtypeid: number;
	// 0：正常，1：下架
	state: number;
	// createtime
	createtime: string;
}