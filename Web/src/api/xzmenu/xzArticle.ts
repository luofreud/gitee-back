import {useBaseApi} from '/@/api/base';

// 用户发布文章接口服务
export const useXzArticleApi = () => {
	const baseApi = useBaseApi("xzArticle");
	return {
		// 分页查询用户发布文章
		page: baseApi.page,
		// 查看用户发布文章详细
		detail: baseApi.detail,
		// 新增用户发布文章
		add: baseApi.add,
		// 更新用户发布文章
		update: baseApi.update,
		// 删除用户发布文章
		delete: baseApi.delete,
		// 批量删除用户发布文章
		batchDelete: baseApi.batchDelete,
		// 导出用户发布文章数据
		exportData: baseApi.exportData,
		// 导入用户发布文章数据
		importData: baseApi.importData,
		// 下载用户发布文章数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户发布文章实体
export interface XzArticle {
	// 主键Id
	id: number;
	// 板块id
	plateid: number;
	// 
	uid: number;
	// 内容
	content: string;
	// 图片
	imgs: string;
	// 视频
	videos: string;
	// 话题
	tags: string;
	// 发布板块
	atype: number;
	// 0:否，1：匿名
	isanonymous: number;
	// 点赞
	likecount: number;
	// 评论
	commentcount: number;
	// 收藏
	collectioncount: number;
	// 0：不置顶，1：置顶
	istop: number;
	// createtime
	createtime: string;
}