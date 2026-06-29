import {useBaseApi} from '/@/api/base';

// 新闻内容接口服务
export const useXzNewsApi = () => {
	const baseApi = useBaseApi("xzNews");
	return {
		// 分页查询新闻内容
		page: baseApi.page,
		// 查看新闻内容详细
		detail: baseApi.detail,
		// 新增新闻内容
		add: baseApi.add,
		// 更新新闻内容
		update: baseApi.update,
		// 删除新闻内容
		delete: baseApi.delete,
		// 批量删除新闻内容
		batchDelete: baseApi.batchDelete,
		// 导出新闻内容数据
		exportData: baseApi.exportData,
		// 导入新闻内容数据
		importData: baseApi.importData,
		// 下载新闻内容数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 新闻内容实体
export interface XzNews {
	// 主键Id
	id: number;
	// 标题
	title: string;
	// 标题key
	titlecode: string;
	// 图标
	img: string;
	// 内容
	newcontent: string;
	// 点击次数
	click: number;
	// 排序
	sortcode: number;
	// 创建时间
	createtime: string;
}