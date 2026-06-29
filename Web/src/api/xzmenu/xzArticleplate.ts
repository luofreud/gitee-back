import {useBaseApi} from '/@/api/base';

// 板块接口服务
export const useXzArticleplateApi = () => {
	const baseApi = useBaseApi("xzArticleplate");
	return {
		// 分页查询板块
		page: baseApi.page,
		// 查看板块详细
		detail: baseApi.detail,
		// 新增板块
		add: baseApi.add,
		// 更新板块
		update: baseApi.update,
		// 删除板块
		delete: baseApi.delete,
		// 批量删除板块
		batchDelete: baseApi.batchDelete,
		// 导出板块数据
		exportData: baseApi.exportData,
		// 导入板块数据
		importData: baseApi.importData,
		// 下载板块数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 板块实体
export interface XzArticleplate {
	// 主键Id
	id: number;
	// 内容
	content: string;
	// 热度
	ishot: number;
	// 新
	isnew: number;
	// 关联数量
	count: number;
	// 0：不置顶，1：置顶
	istop: number;
	// createtime
	createtime: string;
}