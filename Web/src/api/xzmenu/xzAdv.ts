import {useBaseApi} from '/@/api/base';

// 系统广告接口服务
export const useXzAdvApi = () => {
	const baseApi = useBaseApi("xzAdv");
	return {
		// 分页查询系统广告
		page: baseApi.page,
		// 查看系统广告详细
		detail: baseApi.detail,
		// 新增系统广告
		add: baseApi.add,
		// 更新系统广告
		update: baseApi.update,
		// 删除系统广告
		delete: baseApi.delete,
		// 批量删除系统广告
		batchDelete: baseApi.batchDelete,
		// 导出系统广告数据
		exportData: baseApi.exportData,
		// 导入系统广告数据
		importData: baseApi.importData,
		// 下载系统广告数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 系统广告实体
export interface XzAdv {
	// 主键Id
	id: number;
	// 广告名称
	name: string;
	// 广告图片
	img: string;
	// 广告位置
	postion: number;
	// 开始时间
	stime: string;
	// 结束时间
	etime: string;
	// 排序
	sortcode: number;
	// 跳转地址
	url: string;
	// 0：启用，1：不显示
	isenable: number;
	// 点击次数
	click: number;
	// 时间
	createtime: string;
}