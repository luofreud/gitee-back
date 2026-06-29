import {useBaseApi} from '/@/api/base';

// 用户评论列表接口服务
export const useXzArticlecommentsApi = () => {
	const baseApi = useBaseApi("xzArticlecomments");
	return {
		// 分页查询用户评论列表
		page: baseApi.page,
		// 查看用户评论列表详细
		detail: baseApi.detail,
		// 新增用户评论列表
		add: baseApi.add,
		// 更新用户评论列表
		update: baseApi.update,
		// 删除用户评论列表
		delete: baseApi.delete,
		// 批量删除用户评论列表
		batchDelete: baseApi.batchDelete,
		// 导出用户评论列表数据
		exportData: baseApi.exportData,
		// 导入用户评论列表数据
		importData: baseApi.importData,
		// 下载用户评论列表数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户评论列表实体
export interface XzArticlecomments {
	// 主键Id
	id: number;
	// 
	uid: number;
	// 
	aid: number;
	// 内容
	content: string;
	// 点赞数量
	likecount: number;
	// 父级
	parentid: number;
	// 回复数量
	replycount: number;
	// 0：正常，1：待审核，2：禁用
	state: number;
	// createtime
	createtime: string;
}