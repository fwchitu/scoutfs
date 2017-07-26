#ifndef _SCOUTFS_CLIENT_H_
#define _SCOUTFS_CLIENT_H_

int scoutfs_client_alloc_inodes(struct super_block *sb);
int scoutfs_client_alloc_segno(struct super_block *sb, u64 *segno);
int scoutfs_client_record_segment(struct super_block *sb,
				  struct scoutfs_segment *seg, u8 level);
u64 *scoutfs_client_bulk_alloc(struct super_block *sb);
int scoutfs_client_advance_seq(struct super_block *sb, u64 *seq);
int scoutfs_client_get_last_seq(struct super_block *sb, u64 *seq);
int scoutfs_client_get_manifest_root(struct super_block *sb,
				     struct scoutfs_btree_root *root);

int scoutfs_client_setup(struct super_block *sb);
void scoutfs_client_destroy(struct super_block *sb);

#endif
